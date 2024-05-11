import 'package:common_models/common_models.dart';

import '../model/playlist.dart';

abstract interface class PlaylistLocalRepository {
  Future<Result<int>> deleteByIds(List<String> ids);

  Future<EmptyResult> bulkWrite(List<Playlist> playlists);

  Future<Result<List<String>>> getAllIds();
}
