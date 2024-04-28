import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_user_audio_likes.dart';

@LazySingleton(as: SyncUserAudioLikes)
final class SyncUserAudioLikesImpl extends SyncEntityBase implements SyncUserAudioLikes {
  SyncUserAudioLikesImpl(
    this._audioLocalRepository,
    this._audioRemoteRepository,
    this._authUserInfoProvider,
  );

  final AudioLocalRepository _audioLocalRepository;
  final AudioRemoteRepository _audioRemoteRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync audio likes, authUserId is null');
      return EmptyResult.err();
    }

    final res = await _audioLocalRepository.deleteAudioLikesByUserIdAndAudioIds(
      userId: authUserId,
      audioIds: ids,
    );

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final audioLikes = await _audioRemoteRepository.getAuthUserAudioLikesByAudioIds(audioIds: ids);
    if (audioLikes.isLeft) {
      return EmptyResult.err();
    }

    return _audioLocalRepository.bulkWriteAudioLikes(audioLikes.rightOrThrow);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync audio likes, authUserId is null');
      return null;
    }

    final localUserAudioLikesRes = await _audioLocalRepository.getAllAudioLikesByUserId(userId: authUserId);

    return localUserAudioLikesRes.dataOrNull?.map((e) => e.audioId).whereNotNull().toList();
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final audioLikes = await _audioRemoteRepository.getAuthUserAudioLikes();

    return audioLikes.rightOrNull?.map((e) => e.audioId).whereNotNull().toList();
  }
}
