import 'package:audio_service/audio_service.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../entities/audio/util/audio_extension.dart';
import '../../../shared/values/constant.dart';

@lazySingleton
class MediaItemMapper {
  MediaItem audioToMediaItem(Audio audio) {
    return MediaItem(
      id: audio.id ?? audio.localId?.toString() ?? kInvalidId,
      title: audio.title,
      artist: audio.author,
      duration: Duration(milliseconds: audio.durationMs),
      artUri: audio.thumbnailUri,
      extras: {'audio': audio},
    );
  }
}
