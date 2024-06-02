import 'package:common_models/common_models.dart';

import '../model/playlist_audio_dto.dart';

abstract interface class PlaylistAudioRemoteService {
  Future<Either<NetworkCallError, List<PlaylistAudioDto>>> getAll({
    required List<String> ids,
  });

  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUserPlaylists();
}
