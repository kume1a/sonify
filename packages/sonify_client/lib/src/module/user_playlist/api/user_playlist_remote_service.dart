import 'package:common_models/common_models.dart';

import '../model/user_playlist_dto.dart';

abstract interface class UserPlaylistRemoteService {
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser();

  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllByAuthUser({
    required List<String>? ids,
  });

  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllFullByAuthUser({
    required List<String>? playlistIds,
  });

  Future<Either<NetworkCallError, List<String>>> getAllPlaylistIdsByAuthUser();

  Future<Either<NetworkCallError, UserPlaylistDto>> create({
    required String name,
  });

  Future<Either<NetworkCallError, UserPlaylistDto>> updateById({
    required String id,
    required String? name,
  });

  Future<Either<NetworkCallError, Unit>> deleteById(String id);
}
