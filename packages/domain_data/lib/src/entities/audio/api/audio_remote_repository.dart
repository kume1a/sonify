import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';

abstract interface class AudioRemoteRepository {
  Future<Either<DownloadYoutubeAudioFailure, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<UploadUserLocalMusicFailure, UserAudio>> uploadUserLocalMusic({
    required String localId,
    required String title,
    required String? author,
    required int? durationMs,
    required Uint8List audio,
    required Uint8List? thumbnail,
  });

  Future<Either<FetchFailure, List<int>>> getAuthUserAudioIds();

  Future<Either<FetchFailure, List<Audio>>> getAudiosByIds(List<int> ids);
}
