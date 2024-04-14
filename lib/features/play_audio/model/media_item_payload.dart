import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_payload.freezed.dart';

@freezed
class MediaItemPayload with _$MediaItemPayload {
  const factory MediaItemPayload({
    required Audio audio,
    required String? playlistId,
  }) = _MediaItemPayload;

  const MediaItemPayload._();

  factory MediaItemPayload.fromExtras(Map<String, dynamic> extras) {
    return MediaItemPayload(
      audio: extras['audio'] as Audio,
      playlistId: extras['playlistId'] as String?,
    );
  }

  Map<String, dynamic> toExtras() {
    return {
      'audio': audio,
      'playlistId': playlistId,
    };
  }
}
