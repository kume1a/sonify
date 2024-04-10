import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';

abstract interface class AudioRemoteRepository {
  Future<Either<DownloadYoutubeAudioFailure, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  });
}
