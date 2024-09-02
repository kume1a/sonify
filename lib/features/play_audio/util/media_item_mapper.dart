import 'package:audio_service/audio_service.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../entities/audio/util/audio_extension.dart';
import '../../../shared/values/constant.dart';
import '../../dynamic_client/api/dynamic_api_url_provider.dart';
import '../model/media_item_payload.dart';

@lazySingleton
class MediaItemMapper {
  MediaItem audioToMediaItem({
    required Audio audio,
    String? playlistId,
  }) {
    return MediaItem(
      id: audio.id ?? kInvalidId,
      title: audio.title,
      artist: audio.author,
      duration: Duration(milliseconds: audio.durationMs),
      artUri: audio.thumbnailUri(apiUrl: staticGetDynamicApiUrl()),
      extras: MediaItemPayload(
        audio: audio,
        playlistId: playlistId,
      ).toExtras(),
    );
  }
}
