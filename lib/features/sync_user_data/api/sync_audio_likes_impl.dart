import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_audio_likes.dart';

@LazySingleton(as: SyncAudioLikes)
final class SyncAudioLikesImpl extends SyncEntityBase implements SyncAudioLikes {
  SyncAudioLikesImpl(
    this._audioLikeLocalRepository,
    this._audioLikeRemoteRepository,
    this._authUserInfoProvider,
  );

  final AudioLikeLocalRepository _audioLikeLocalRepository;
  final AudioLikeRemoteRepository _audioLikeRemoteRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync audio likes, authUserId is null');
      return EmptyResult.err();
    }

    final res = await _audioLikeLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final audioLikes = await _audioLikeRemoteRepository.getAuthUserAudioLikes(ids: ids);
    if (audioLikes.isLeft) {
      return EmptyResult.err();
    }

    return _audioLikeLocalRepository.bulkCreate(audioLikes.rightOrThrow);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync audio likes, authUserId is null');
      return null;
    }

    final localUserAudioLikesRes = await _audioLikeLocalRepository.getAllByUserId(userId: authUserId);

    return localUserAudioLikesRes.dataOrNull?.map((e) => e.id).nonNulls.toList();
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final audioLikes = await _audioLikeRemoteRepository.getAuthUserAudioLikes();

    return audioLikes.rightOrNull?.map((e) => e.id).nonNulls.toList();
  }
}
