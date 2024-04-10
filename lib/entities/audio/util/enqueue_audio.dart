import 'package:audio_service/audio_service.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../../../shared/values/constant.dart';
import 'audio_extension.dart';

@lazySingleton
final class EnqueueAudio {
  EnqueueAudio(
    this._audioHandler,
  );

  final AudioHandler _audioHandler;

  Future<void> fromAudio(Audio audio) async {
    final mediaItem = MediaItem(
      id: audio.id ?? audio.localId?.toString() ?? kInvalidId,
      title: audio.title,
      artist: audio.author,
      duration: Duration(milliseconds: audio.durationMs),
      artUri: audio.thumbnailUri,
      extras: {
        'remoteUrl': assembleResourceUrl(audio.path),
        'audio': audio,
      },
    );

    await _audioHandler.updateQueue([]);
    await _audioHandler.insertQueueItem(0, mediaItem);
  }
}
