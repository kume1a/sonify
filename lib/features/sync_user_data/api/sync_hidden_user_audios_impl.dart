import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_hidden_user_audios.dart';

@LazySingleton(as: SyncHiddenUserAudios)
final class SyncHiddenUserAudiosImpl extends SyncEntityBase implements SyncHiddenUserAudios {
  SyncHiddenUserAudiosImpl(
    this._hiddenUserAudioLocalRepository,
    // this._hiddenUserAudioRemoteRepository,
    this._authUserInfoProvider,
  );

  final HiddenUserAudioLocalRepository _hiddenUserAudioLocalRepository;
  // final HiddenUserAudioRemoteRepository _hiddenUserAudioRemoteRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  // TODO implement

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync hidden user audios, authUserId is null');
      return EmptyResult.err();
    }

    final res = await _hiddenUserAudioLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    // final audioLikes = await _hiddenUserAudioRemoteRepository.getAuthUser(ids: ids);
    // if (audioLikes.isLeft) {
    //   return EmptyResult.err();
    // }

    // return _hiddenUserAudioLocalRepository.bulkCreate(audioLikes.rightOrThrow);

    return EmptyResult.success();
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    // final authUserId = await _authUserInfoProvider.getId();
    // if (authUserId == null) {
    //   Logger.root.warning('sync audio likes, authUserId is null');
    //   return null;
    // }

    // final localUserAudioLikesRes = await _hiddenUserAudioLocalRepository.getAllByUserId(userId: authUserId);

    // return localUserAudioLikesRes.dataOrNull?.map((e) => e.id).whereNotNull().toList();
    return [];
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    // final audioLikes = await _hiddenUserAudioRemoteRepository.getAuthUserAudioLikes();

    // return audioLikes.rightOrNull?.map((e) => e.id).whereNotNull().toList();

    return [];
  }
}
