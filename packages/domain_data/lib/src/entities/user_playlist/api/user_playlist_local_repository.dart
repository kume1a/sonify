import 'package:common_models/common_models.dart';

import '../model/user_playlist.dart';

abstract interface class UserPlaylistLocalRepository {
  Future<EmptyResult> bulkWrite(List<UserPlaylist> userPlaylists);

  Future<Result<int>> deleteByIds(List<String> playlistIds);

  Future<Result<List<UserPlaylist>>> getAllByUserId(String userId);

  Future<Result<List<String>>> getAllIdsByUserId(String userId);

  Future<Result<UserPlaylist>> create(UserPlaylist userPlaylist);

  Future<EmptyResult> updateById({
    required String id,
    String? name,
  });

  Future<EmptyResult> deleteById(String id);

  Future<Result<UserPlaylist?>> getById(String id);

  Future<Result<UserPlaylist?>> getByUserIdAndPlaylistId({
    required String userId,
    required String playlistId,
  });
}
