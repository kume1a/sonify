import 'package:common_models/common_models.dart';

import '../model/user_playlist.dart';

abstract interface class UserPlaylistLocalRepository {
  Future<EmptyResult> bulkWrite(List<UserPlaylist> userPlaylists);

  Future<Result<int>> deleteByIds(List<String> playlistIds);

  Future<Result<List<UserPlaylist>>> getAllByUserId(String userId);

  Future<Result<List<String>>> getAllIdsByUserId(String userId);
}
