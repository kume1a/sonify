import 'package:common_models/common_models.dart';

class SyncUserAudioResult {
  SyncUserAudioResult({
    required this.queuedDownloadsCount,
  });

  final int queuedDownloadsCount;
}

abstract interface class SyncUserAudio {
  Future<Result<SyncUserAudioResult>> call();
}
