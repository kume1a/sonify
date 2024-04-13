import 'package:audio_service/audio_service.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import 'media_item_mapper.dart';

@lazySingleton
final class EnqueuePlaylist {
  EnqueuePlaylist(
    this._audioHandler,
    this._mediaItemMapper,
  );

  final AudioHandler _audioHandler;
  final MediaItemMapper _mediaItemMapper;

  Future<void> call(List<Audio> audios) {
    final mediaItems = audios.map(_mediaItemMapper.audioToMediaItem).toList();

    return _audioHandler.updateQueue(mediaItems);
  }
}
