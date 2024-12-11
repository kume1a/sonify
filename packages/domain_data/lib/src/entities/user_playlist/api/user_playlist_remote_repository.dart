import 'package:common_models/common_models.dart';

import '../model/user_playlist.dart';

abstract interface class UserPlaylistRemoteRepository {
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser();

  Future<Either<NetworkCallError, List<UserPlaylist>>> getAllByAuthUser({
    List<String>? ids,
  });

  Future<Either<NetworkCallError, List<UserPlaylist>>> getAllFullByAuthUser({
    List<String>? playlistIds,
  });

  Future<Either<NetworkCallError, List<String>>> getAllPlaylistIdsByAuthUser();

  Future<Either<NetworkCallError, UserPlaylist>> create({
    required String name,
  });

  Future<Either<NetworkCallError, UserPlaylist>> updateById({
    required String id,
    String? name,
  });

  Future<Either<NetworkCallError, Unit>> deleteById(String id);
}
