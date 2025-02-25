import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

class SyncEntitiesResult {
  SyncEntitiesResult({
    required this.toDownloadCount,
    required this.toDeleteCount,
  });

  final int toDownloadCount;
  final int toDeleteCount;
}

abstract base class SyncEntityBase {
  Future<List<String>?> getRemoteEntityIds();

  Future<List<String>?> getLocalEntityIds();

  Future<EmptyResult> deleteLocalEntities(List<String> ids);

  Future<EmptyResult> downloadEntities(List<String> ids);

  Future<EmptyResult> beforeSync() {
    return Future.value(EmptyResult.success());
  }

  Future<Result<SyncEntitiesResult>> call() async {
    final beforeSyncRes = await beforeSync();
    if (beforeSyncRes.isErr) {
      Logger.root.fine('Failed to run before sync');
      return Result.err();
    }

    final remoteIds = await getRemoteEntityIds();

    if (remoteIds == null) {
      Logger.root.fine('Failed to get remote ids');
      return Result.err();
    }

    final localIds = await getLocalEntityIds();
    if (localIds == null) {
      Logger.root.fine('Failed to get local ids');
      return Result.err();
    }

    final remoteIdsSet = remoteIds.toSet();
    final localIdsSet = localIds.toSet();

    final toDownloadAudioIds = remoteIdsSet.difference(localIdsSet).toList();
    final toDeleteAudioIds = localIdsSet.difference(remoteIdsSet).toList();

    if (toDeleteAudioIds.isNotEmpty) {
      final deleteRes = await deleteLocalEntities(toDeleteAudioIds);

      if (deleteRes.isErr) {
        Logger.root.warning('Failed to delete remote entities');
        return Result.err();
      }
    }

    if (toDownloadAudioIds.isEmpty) {
      return Result.success(
        SyncEntitiesResult(
          toDownloadCount: 0,
          toDeleteCount: toDeleteAudioIds.length,
        ),
      );
    }

    final downloadRes = await downloadEntities(toDownloadAudioIds);

    if (downloadRes.isErr) {
      Logger.root.warning('Failed to download remote entities');
      return Result.err();
    }

    return Result.success(
      SyncEntitiesResult(
        toDownloadCount: toDownloadAudioIds.length,
        toDeleteCount: toDeleteAudioIds.length,
      ),
    );
  }
}

abstract base class FullSyncEntityBase {
  Future<List<String>?> getLocalEntityIds();

  Future<EmptyResult> deleteLocalEntities(List<String> ids);

  Future<EmptyResult> downloadEntities();

  Future<EmptyResult> beforeSync() {
    return Future.value(EmptyResult.success());
  }

  Future<EmptyResult> call() async {
    final beforeSyncRes = await beforeSync();
    if (beforeSyncRes.isErr) {
      Logger.root.fine('Failed to run before sync');
      return EmptyResult.err();
    }

    final localIds = await getLocalEntityIds();

    if (localIds != null && localIds.isNotEmpty) {
      final deleteRes = await deleteLocalEntities(localIds);

      if (deleteRes.isErr) {
        Logger.root.warning('Failed to delete local entities');
        return EmptyResult.err();
      }
    }

    final downloadRes = await downloadEntities();

    if (downloadRes.isErr) {
      Logger.root.warning('Failed to download remote entities');
      return EmptyResult.err();
    }

    return EmptyResult.success();
  }
}
