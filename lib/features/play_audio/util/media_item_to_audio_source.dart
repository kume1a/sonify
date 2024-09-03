import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/util/audio_extension.dart';
import '../../../shared/util/utils.dart';
import '../../dynamic_client/api/dynamic_api_url_provider.dart';
import '../model/media_item_payload.dart';

UriAudioSource? mediaItemToAudioSource(MediaItem mediaItem) {
  if (mediaItem.extras == null) {
    Logger.root.warning('Media extras is null, mediaItem: $mediaItem');
    return null;
  }

  final payload = callOrDefault(
    () => MediaItemPayload.fromExtras(mediaItem.extras ?? {}),
    null,
  );
  if (payload == null) {
    Logger.root.warning('MediaItemPayload is null, mediaItem: $mediaItem');
    return null;
  }

  final audioUri = payload.audio.audioUri(apiUrl: staticGetDynamicApiUrl());
  if (audioUri == null) {
    Logger.root.warning('Audio uri is null, audio: ${payload.audio}');
    return null;
  }

  Logger.root.info('Audio uri: $audioUri');

  return AudioSource.uri(
    audioUri,
    tag: mediaItem,
  );
}
