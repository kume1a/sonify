import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import 'sync_user_audio_likes.dart';

@LazySingleton(as: SyncUserAudioLikes)
class SyncUserAudioLikesImpl implements SyncUserAudioLikes {
  SyncUserAudioLikesImpl(
    this._audioLocalRepository,
    this._audioRemoteRepository,
    this._authUserInfoProvider,
  );

  final AudioLocalRepository _audioLocalRepository;
  final AudioRemoteRepository _audioRemoteRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<EmptyResult> call() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      return EmptyResult.err();
    }

    final localUserAudioLikesRes = await _audioLocalRepository.getAllLikedAudiosByUserId(userId: authUserId);
    if (localUserAudioLikesRes.isErr) {
      return EmptyResult.err();
    }

    final localUserAudioLikeAudioIds =
        localUserAudioLikesRes.getOrElse(() => []).map((e) => e.audioId).whereNotNull().toList();

    final syncUserAudioLikesRes =
        await _audioRemoteRepository.syncAudioLikes(audioIds: localUserAudioLikeAudioIds);

    if (syncUserAudioLikesRes.isLeft) {
      return EmptyResult.err();
    }

    return EmptyResult.success();
  }
}
