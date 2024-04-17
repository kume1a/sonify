import 'package:common_models/common_models.dart';

enum SyncUserAudioError {
  unknown,
  network,
}

class SyncUserAudioResult {
  SyncUserAudioResult({
    required this.queuedDownloadsCount,
  });

  final int queuedDownloadsCount;
}

abstract interface class SyncUserAudio {
  Future<Either<SyncUserAudioError, SyncUserAudioResult>> call();
}
