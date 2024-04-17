import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../auth/api/auth_user_info_provider.dart';
import '../../download_file/model/download_task.dart';
import '../../download_file/model/downloads_event.dart';
import 'sync_user_audio.dart';

@LazySingleton(as: SyncUserAudio)
class SyncUserAudioImpl implements SyncUserAudio {
  SyncUserAudioImpl(
    this._audioRemoteRepository,
    this._audioLocalRepository,
    this._authUserInfoProvider,
    this._eventBus,
  );

  final AudioRemoteRepository _audioRemoteRepository;
  final AudioLocalRepository _audioLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final EventBus _eventBus;

  @override
  Future<Either<SyncUserAudioFailure, SyncUserAudioResult>> call() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('Auth user id is null, cannot sync user audio');
      return left(SyncUserAudioFailure.unknown);
    }

    final userAudioIdsRes = await _audioRemoteRepository.getAuthUserAudioIds();

    if (userAudioIdsRes.isLeft) {
      Logger.root.fine('Failed to get user audio ids: ${userAudioIdsRes.leftOrNull}');
      return left(userAudioIdsRes.leftOrThrow.maybeWhen(
        orElse: () => SyncUserAudioFailure.unknown,
        network: () => SyncUserAudioFailure.network,
      ));
    }

    final userLocalAudios = await _audioLocalRepository.getAllByUserId(authUserId);

    final remoteUserAudioIds = userAudioIdsRes.rightOrThrow.toSet();
    final userLocalAudioIds = userLocalAudios.map((e) => e.audio?.id).whereNotNull().toSet();

    final toDownloadAudioIds = remoteUserAudioIds.difference(userLocalAudioIds).toList();
    final toDeleteLocalUserAudioIds = userLocalAudios
        .where((e) => e.audio != null && !remoteUserAudioIds.contains(e.audio?.id))
        .map((e) => e.localId)
        .whereNotNull()
        .toList();

    final toDownloadUserAudiosRes =
        await _audioRemoteRepository.getAuthUserAudiosByAudioIds(toDownloadAudioIds);

    if (toDownloadUserAudiosRes.isLeft) {
      Logger.root.fine('Failed to download audios: ${toDownloadUserAudiosRes.leftOrNull}');
      return left(toDownloadUserAudiosRes.leftOrThrow.maybeWhen(
        orElse: () => SyncUserAudioFailure.unknown,
        network: () => SyncUserAudioFailure.network,
      ));
    }

    final toDownloadUserAudios = toDownloadUserAudiosRes.rightOrThrow;

    await _audioLocalRepository.deleteUserAudioJoinsByIds(toDeleteLocalUserAudioIds);

    final toDownloadUserAudiosLen = toDownloadUserAudios.length;
    for (int i = 0; i < toDownloadUserAudiosLen; i++) {
      _eventBus.fire(
        DownloadsEvent.enqueueUserAudio(
          toDownloadUserAudios[i],
          syncAudioPayload: DownloadTaskSyncAudioPayload(
            index: i,
            totalCount: toDownloadUserAudiosLen,
          ),
        ),
      );
    }

    return right(SyncUserAudioResult(queuedDownloadsCount: toDownloadUserAudiosLen));
  }
}
