import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../download_file/model/downloads_event.dart';
import '../util/sync_entity_base.dart';
import 'sync_user_audio.dart';

@LazySingleton(as: SyncUserAudio)
final class SyncUserAudioImpl extends SyncEntityBase implements SyncUserAudio {
  SyncUserAudioImpl(
    this._userAudioRemoteRepository,
    this._userAudioLocalRepository,
    this._authUserInfoProvider,
    this._eventBus,
  );

  final UserAudioRemoteRepository _userAudioRemoteRepository;
  final UserAudioLocalRepository _userAudioLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final EventBus _eventBus;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _userAudioLocalRepository.deleteByAudioIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final toDownloadUserAudiosRes = await _userAudioRemoteRepository.getAuthUserAudiosByAudioIds(ids);
    if (toDownloadUserAudiosRes.isLeft) {
      return EmptyResult.err();
    }

    for (final userAudio in toDownloadUserAudiosRes.rightOrThrow) {
      _eventBus.fire(
        DownloadsEvent.enqueueUserAudio(userAudio),
      );
    }

    return EmptyResult.success();
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('Auth user id is null, cannot sync user audio');
      return null;
    }

    final userLocalAudiosRes = await _userAudioLocalRepository.getAllAudioIdsByUserId(authUserId);

    return userLocalAudiosRes.dataOrNull;
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final res = await _userAudioRemoteRepository.getAuthUserAudioIds();

    return res.rightOrNull;
  }
}
