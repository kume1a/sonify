import 'package:common_models/common_models.dart';

enum SyncUserAudioFailure {
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
  Future<Either<SyncUserAudioFailure, SyncUserAudioResult>> call();
}
