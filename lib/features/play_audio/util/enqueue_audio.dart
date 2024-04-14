import 'package:audio_service/audio_service.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import 'media_item_mapper.dart';

@lazySingleton
final class EnqueueAudio {
  EnqueueAudio(
    this._audioHandler,
    this._mediaItemMapper,
  );

  final AudioHandler _audioHandler;
  final MediaItemMapper _mediaItemMapper;

  Future<void> call(Audio audio) async {
    final mediaItem = _mediaItemMapper.audioToMediaItem(audio: audio);

    return _audioHandler.updateQueue([mediaItem]);
  }
}
