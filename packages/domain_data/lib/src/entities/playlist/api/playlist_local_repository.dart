import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/playlist.dart';

abstract interface class PlaylistLocalRepository {
  Future<Result<int>> deleteByIds(List<String> ids);

  Future<EmptyResult> bulkWrite(List<Playlist> playlists);

  Future<Result<Playlist?>> getById(String id);

  Future<Result<Playlist>> create(Playlist playlist);

  Future<EmptyResult> updateById({
    required String id,
    String? name,
  });

  Future<EmptyResult> deleteById(
    String playlistId, {
    DbBatchProvider? batchProvider,
  });
}
