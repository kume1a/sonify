import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteRepository {
  Future<Either<NetworkCallError, Playlist>> getById(String id);
}
