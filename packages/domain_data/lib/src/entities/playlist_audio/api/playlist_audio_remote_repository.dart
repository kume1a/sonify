import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/playlist_audio.dart';

abstract interface class PlaylistAudioRemoteRepository {
  Future<Either<NetworkCallError, List<PlaylistAudio>>> getAllByAuthUser({
    required List<String> ids,
  });

  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser();

  Future<Either<CreatePlaylistAudioError, PlaylistAudio>> create({
    required String playlistId,
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> deleteByPlaylistIdAndAudioId({
    required String playlistId,
    required String audioId,
  });
}
