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

  Future<void> call(Playlist playlist) {
    final mediaItems = playlist.audios
            ?.map((audio) => _mediaItemMapper.audioToMediaItem(audio: audio, playlistId: playlist.id))
            .toList() ??
        [];

    return _audioHandler.updateQueue(mediaItems);
  }
}
