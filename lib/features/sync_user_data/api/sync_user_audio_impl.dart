import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

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
  Future<Result<SyncUserAudioResult>> call() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('Auth user id is null, cannot sync user audio');
      return Result.err();
    }

    final userAudioIdsRes = await _audioRemoteRepository.getAuthUserAudioIds();

    if (userAudioIdsRes.isLeft) {
      Logger.root.fine('Failed to get user audio ids: ${userAudioIdsRes.leftOrNull}');
      return Result.err();
    }

    final userLocalAudiosRes = await _audioLocalRepository.getAllByUserId(authUserId);
    if (userLocalAudiosRes.isErr) {
      Logger.root.fine('Failed to get local user audios: $userLocalAudiosRes');
      return Result.err();
    }

    final userLocalAudios = userLocalAudiosRes.dataOrThrow;
    final remoteUserAudioIds = userAudioIdsRes.rightOrThrow.toSet();
    final userLocalAudioIds = userLocalAudios.map((e) => e.audio?.id).whereNotNull().toSet();

    final toDownloadAudioIds = remoteUserAudioIds.difference(userLocalAudioIds).toList();
    final toDeleteLocalUserAudioIds = userLocalAudios
        .where((e) => e.audio != null && !remoteUserAudioIds.contains(e.audio?.id))
        .map((e) => e.localId)
        .whereNotNull()
        .toList();

    if (toDeleteLocalUserAudioIds.isNotEmpty) {
      await _audioLocalRepository.deleteUserAudioJoinsByIds(toDeleteLocalUserAudioIds);
    }

    if (toDownloadAudioIds.isEmpty) {
      return Result.success(SyncUserAudioResult(queuedDownloadsCount: 0));
    }

    final toDownloadUserAudiosRes =
        await _audioRemoteRepository.getAuthUserAudiosByAudioIds(toDownloadAudioIds);

    if (toDownloadUserAudiosRes.isLeft) {
      Logger.root.fine('Failed to download audios: ${toDownloadUserAudiosRes.leftOrNull}');
      return Result.err();
    }

    final toDownloadUserAudios = toDownloadUserAudiosRes.rightOrThrow;

    final toDownloadUserAudiosLen = toDownloadUserAudios.length;
    for (int i = 0; i < toDownloadUserAudiosLen; i++) {
      _eventBus.fire(
        DownloadsEvent.enqueueUserAudio(toDownloadUserAudios[i]),
      );
    }

    final res = SyncUserAudioResult(queuedDownloadsCount: toDownloadUserAudiosLen);
    return Result.success(res);
  }
}
