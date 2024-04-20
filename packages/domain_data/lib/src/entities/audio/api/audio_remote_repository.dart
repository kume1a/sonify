import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';

abstract interface class AudioRemoteRepository {
  Future<Either<DownloadYoutubeAudioError, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<UploadUserLocalMusicError, UserAudio>> uploadUserLocalMusic({
    required String localId,
    required String title,
    required String? author,
    required int? durationMs,
    required Uint8List audio,
    required Uint8List? thumbnail,
  });

  Future<Either<NetworkCallError, List<String>>> getAuthUserAudioIds();

  Future<Either<NetworkCallError, List<UserAudio>>> getAuthUserAudiosByAudioIds(List<String> audioIds);

  Future<Either<NetworkCallError, Unit>> likeAudio({
    required String audioId,
  });

  Future<Either<NetworkCallError, Unit>> unlikeAudio({
    required String audioId,
  });
}
