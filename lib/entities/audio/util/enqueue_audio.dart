import 'package:audio_service/audio_service.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../model/local_audio_file.dart';
import 'audio_extension.dart';

@lazySingleton
final class EnqueueAudio {
  EnqueueAudio(
    this._audioHandler,
  );

  final AudioHandler _audioHandler;

  Future<void> fromAudio(Audio audio) async {
    final mediaItem = MediaItem(
      id: audio.id,
      title: audio.title,
      artist: audio.author,
      duration: Duration(milliseconds: audio.durationMs),
      artUri: audio.thumbnailUri,
      extras: {
        'remoteUrl': assembleResourceUrl(audio.path),
        'audioId': audio.id,
      },
    );

    await _audioHandler.updateQueue([]);
    await _audioHandler.insertQueueItem(0, mediaItem);
  }

  Future<void> fromLocalAudioFile(LocalAudioFile localAudioFile) async {
    final mediaItem = MediaItem(
      id: localAudioFile.id.toString(),
      title: localAudioFile.title,
      artist: localAudioFile.author,
      duration: localAudioFile.duration,
      artUri: localAudioFile.thumbnailPath != null ? Uri.parse(localAudioFile.thumbnailPath!) : null,
      extras: {
        'localPath': localAudioFile.path,
        'localAudioFileId': localAudioFile.id,
      },
    );

    await _audioHandler.updateQueue([]);
    await _audioHandler.insertQueueItem(0, mediaItem);
  }
}
