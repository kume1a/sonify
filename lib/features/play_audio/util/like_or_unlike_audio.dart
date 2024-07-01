import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

@lazySingleton
class LikeOrUnlikeAudio {
  LikeOrUnlikeAudio(
    this._authUserInfoProvider,
    this._audioLikeRemoteRepository,
    this._audioLikeLocalRepository,
    this._pendingChangeLocalRepository,
  );

  final AuthUserInfoProvider _authUserInfoProvider;
  final AudioLikeRemoteRepository _audioLikeRemoteRepository;
  final AudioLikeLocalRepository _audioLikeLocalRepository;
  final PendingChangeLocalRepository _pendingChangeLocalRepository;

  Future<Audio?> call({
    required Audio? nowPlayingAudio,
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

    final alreadyLikedRes = await _audioLikeLocalRepository.existsByUserAndAudioId(
      userId: authUserId,
      audioId: nowPlayingAudioId,
    );

    if (alreadyLikedRes.isErr) {
      Logger.root.warning('NowPlayingAudioCubit.onLikePressed: failed to check if already liked');
      return null;
    }

    if (alreadyLikedRes.dataOrThrow) {
      final unlikeRes = await _audioLikeLocalRepository.deleteByAudioAndUserId(
          userId: authUserId, audioId: nowPlayingAudioId);

      return unlikeRes.ifSuccess(
        () {
          // don't await for speed
          _unlikeAudioRemote(audioId: nowPlayingAudioId, userId: authUserId);

          return nowPlayingAudio.copyWith(audioLike: null);
        },
      );
    } else {
      final audioLike = AudioLike(
        id: null,
        audioId: nowPlayingAudioId,
        userId: authUserId,
      );

      final likeRes = await _audioLikeLocalRepository.create(audioLike);

      return likeRes.ifSuccess(
        (r) {
          // don't await for speed
          _likeAudioRemote(audioId: nowPlayingAudioId, userId: authUserId);

          return nowPlayingAudio.copyWith(audioLike: r);
        },
      );
    }
  }

  Future<void> _likeAudioRemote({
    required String audioId,
    required String userId,
  }) async {
    final res = await _audioLikeRemoteRepository.likeAudio(audioId: audioId);

    await res.ifLeft((_) {
      final pendingChange = PendingChange(
        id: null,
        type: PendingChangeType.createLike,
        payload: PendingChangePayload.createLike(
          AudioLike(
            id: null,
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
    final res = await _audioLikeRemoteRepository.unlikeAudio(audioId: audioId);

    await res.ifLeft((_) {
      final pendingChange = PendingChange(
        id: null,
        type: PendingChangeType.deleteLike,
        payload: PendingChangePayload.deleteLike(
          AudioLike(
            id: null,
            audioId: audioId,
            userId: userId,
          ),
        ),
      );

      return _pendingChangeLocalRepository.create(pendingChange);
    });
  }
}
