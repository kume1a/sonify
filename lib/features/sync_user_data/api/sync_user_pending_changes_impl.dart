import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'sync_user_pending_changes.dart';

@LazySingleton(as: SyncUserPendingChanges)
class SyncUserPendingChangesImpl implements SyncUserPendingChanges {
  SyncUserPendingChangesImpl(
    this._pendingChangeLocalRepository,
    this._audioRemoteRepository,
  );

  final PendingChangeLocalRepository _pendingChangeLocalRepository;
  final AudioRemoteRepository _audioRemoteRepository;

  @override
  Future<EmptyResult> call() async {
    final pendingChanges = await _pendingChangeLocalRepository.getAllByTypes([
      PendingChangeType.createLike,
      PendingChangeType.deleteLike,
    ]);

    if (pendingChanges.isErr) {
      return EmptyResult.err();
    }

    for (final pendingChange in pendingChanges.dataOrThrow) {
      if (pendingChange.id == null) {
        Logger.root.warning('id is null, cannot sync audio like: $pendingChange');
        return EmptyResult.err();
      }

      final res = await pendingChange.payload.maybeWhen<Future<Either<NetworkCallError, Object?>?>>(
        orElse: () => Future.value(),
        createLike: (audioLike) {
          if (audioLike.audioId == null) {
            Logger.root.warning('Audio id is null, cannot sync audio like: $audioLike');
            return Future.value();
          }

          return _audioRemoteRepository.likeAudio(audioId: audioLike.audioId!);
        },
        deleteLike: (audioLike) {
          if (audioLike.audioId == null) {
            Logger.root.warning('Audio id is null, cannot sync audio like: $audioLike');
            return Future.value();
          }

          return _audioRemoteRepository.unlikeAudio(audioId: audioLike.audioId!);
        },
      );

      if (res == null || res.isLeft) {
        Logger.root.warning('Failed to sync audio like: ${pendingChange.payload.audioLike}');
        return EmptyResult.err();
      }

      await _pendingChangeLocalRepository.deleteById(pendingChange.id!);
    }

    return EmptyResult.success();
  }
}
