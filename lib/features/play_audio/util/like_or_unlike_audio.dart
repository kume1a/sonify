import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

class LikeOrUnlikeAudioResult {
  LikeOrUnlikeAudioResult({
    required this.nowPlayingAudio,
    required this.nowPlayingAudios,
  });

  final Audio nowPlayingAudio;
  final List<Audio>? nowPlayingAudios;

  @override
  String toString() {
    return 'LikeOrUnlikeAudioResult{nowPlayingAudio: $nowPlayingAudio, nowPlayingAudios: $nowPlayingAudios}';
  }
}

@lazySingleton
class LikeOrUnlikeAudio {
  LikeOrUnlikeAudio(
    this._authUserInfoProvider,
    this._audioRemoteRepository,
    this._audioLocalRepository,
    this._pendingChangeLocalRepository,
  );

  final AuthUserInfoProvider _authUserInfoProvider;
  final AudioRemoteRepository _audioRemoteRepository;
  final AudioLocalRepository _audioLocalRepository;
  final PendingChangeLocalRepository _pendingChangeLocalRepository;

  Future<LikeOrUnlikeAudioResult?> call({
    required Audio? nowPlayingAudio,
    required List<Audio>? nowPlayingAudios,
  }) async {
    if (nowPlayingAudio == null || nowPlayingAudio.id == null) {
      Logger.root.warning('LikeOrUnlikeAudio.call: nowPlayingAudio or id is null $nowPlayingAudio');
      return null;
    }

    final nowPlayingAudioId = nowPlayingAudio.id!;

    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('NowPlayingAudioCubit.onLikePressed: authUserId is null');
      return null;
    }

    final alreadyLikedRes = await _audioLocalRepository.existsByUserAndAudioId(
      userId: authUserId,
      audioId: nowPlayingAudioId,
    );

    if (alreadyLikedRes.isErr) {
      Logger.root.warning('NowPlayingAudioCubit.onLikePressed: failed to check if already liked');
      return null;
    }

    if (alreadyLikedRes.dataOrThrow) {
      final unlikeRes = await _audioLocalRepository.deleteAudioLikeByAudioAndUserId(
          userId: authUserId, audioId: nowPlayingAudioId);

      return unlikeRes.ifSuccess(
        () {
          // don't await for speed
          _unlikeAudioRemote(audioId: nowPlayingAudioId, userId: authUserId);

          return _updateAudioLikeAndResolveResult(
            audioLike: null,
            nowPlayingAudio: nowPlayingAudio,
            nowPlayingAudios: nowPlayingAudios,
          );
        },
      );
    } else {
      final audioLike = AudioLike(
        localId: null,
        audioId: nowPlayingAudioId,
        userId: authUserId,
      );

      final likeRes = await _audioLocalRepository.createAudioLike(audioLike);

      return likeRes.ifSuccess(
        (r) {
          // don't await for speed
          _likeAudioRemote(audioId: nowPlayingAudioId, userId: authUserId);

          return _updateAudioLikeAndResolveResult(
            audioLike: r,
            nowPlayingAudio: nowPlayingAudio,
            nowPlayingAudios: nowPlayingAudios,
          );
        },
      );
    }
  }

  LikeOrUnlikeAudioResult _updateAudioLikeAndResolveResult({
    required AudioLike? audioLike,
    required Audio nowPlayingAudio,
    required List<Audio>? nowPlayingAudios,
  }) {
    final updatedNowPlayingAudio = nowPlayingAudio.copyWith(audioLike: audioLike);
    final updatedNowPlayingAudios = nowPlayingAudios?.replace(
      (e) => e.id == nowPlayingAudio.id,
      (_) => updatedNowPlayingAudio,
    );

    return LikeOrUnlikeAudioResult(
      nowPlayingAudio: updatedNowPlayingAudio,
      nowPlayingAudios: updatedNowPlayingAudios,
    );
  }

  Future<void> _likeAudioRemote({
    required String audioId,
    required String userId,
  }) async {
    final res = await _audioRemoteRepository.likeAudio(audioId: audioId);

    await res.ifLeft((_) {
      final pendingChange = PendingChange(
        localId: null,
        type: PendingChangeType.createLike,
        payload: PendingChangePayload.createLike(
          AudioLike(
            localId: null,
            audioId: audioId,
            userId: userId,
          ),
        ),
      );

      return _pendingChangeLocalRepository.create(pendingChange);
    });
  }

  Future<void> _unlikeAudioRemote({
    required String audioId,
    required String userId,
  }) async {
    final res = await _audioRemoteRepository.unlikeAudio(audioId: audioId);

    await res.ifLeft((_) {
      final pendingChange = PendingChange(
        localId: null,
        type: PendingChangeType.deleteLike,
        payload: PendingChangePayload.deleteLike(
          AudioLike(
            localId: null,
            audioId: audioId,
            userId: userId,
          ),
        ),
      );

      return _pendingChangeLocalRepository.create(pendingChange);
    });
  }
}
