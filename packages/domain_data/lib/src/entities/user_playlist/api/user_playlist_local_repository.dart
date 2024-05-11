import 'package:common_models/common_models.dart';

import '../model/user_playlist.dart';

abstract interface class UserPlaylistLocalRepository {
  Future<EmptyResult> bulkWrite(
    List<UserPlaylist> userPlaylists,
  );

  Future<void> deleteByUserIdAndPlaylistIds({
    required String userId,
    required List<String> playlistIds,
  });

  Future<List<String>> getAllPlaylistIdsByUserId(String userId);
}
