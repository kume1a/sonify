import 'package:common_models/common_models.dart';

import '../model/index.dart';

abstract interface class PlaylistRemoteService {
  Future<Either<NetworkCallError, PlaylistDto>> getPlaylistById({
    required String playlistId,
  });
}
