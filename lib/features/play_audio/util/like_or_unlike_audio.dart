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
}

@lazySingleton
class LikeOrUnlikeAudio {
  LikeOrUnlikeAudio(
    this._authUserInfoProvider,
    this._audioRemoteRepository,
    this._audioLocalRepository,
  );

  final AuthUserInfoProvider _authUserInfoProvider;
  final AudioRemoteRepository _audioRemoteRepository;
  final AudioLocalRepository _audioLocalRepository;

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
      final unlikeRes = await _audioLocalRepository.unlike(userId: authUserId, audioId: nowPlayingAudioId);

      return unlikeRes.ifSuccess(
        () {
          // don't await for speed
          _audioRemoteRepository.unlikeAudio(audioId: nowPlayingAudioId);

          return _updateAudioLikeAndResolveResult(
            audioLike: null,
            nowPlayingAudio: nowPlayingAudio,
            nowPlayingAudios: nowPlayingAudios,
          );
        },
      );
    } else {
      final likeRes = await _audioLocalRepository.like(userId: authUserId, audioId: nowPlayingAudioId);

      return likeRes.ifSuccess(
        (r) {
          // don't await for speed
          _audioRemoteRepository.likeAudio(audioId: nowPlayingAudioId);

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
}
