import 'package:common_models/common_models.dart';

import '../model/playlist.dart';

abstract interface class PlaylistCachedRepository {
  Future<Result<Playlist>> getById(String id);
}
