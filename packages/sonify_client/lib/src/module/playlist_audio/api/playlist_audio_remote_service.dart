import 'package:common_models/common_models.dart';

import '../model/playlist_audio_dto.dart';

abstract interface class PlaylistAudioRemoteService {
  Future<Either<NetworkCallError, List<PlaylistAudioDto>>> getAllByAuthUser({
    required List<String> ids,
  });

  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser();

  Future<Either<NetworkCallError, PlaylistAudioDto>> create({
    required String playlistId,
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> deleteByPlaylistIdAndAudioId({
    required String playlistId,
    required String audioId,
  });
}
