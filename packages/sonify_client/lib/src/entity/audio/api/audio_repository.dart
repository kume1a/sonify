import 'package:common_models/common_models.dart';

import '../model/audio.dart';

abstract interface class AudioRepository {
  Future<Either<ActionFailure, Audio>> downloadYoutubeAudio(String videoId);
}
