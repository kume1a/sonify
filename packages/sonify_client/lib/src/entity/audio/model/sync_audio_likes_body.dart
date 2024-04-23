import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_audio_likes_body.g.dart';

part 'sync_audio_likes_body.freezed.dart';

@freezed
class SyncAudioLikesBody with _$SyncAudioLikesBody {
  const factory SyncAudioLikesBody({
    required List<String> audioIds,
  }) = _SyncAudioLikesBody;

  factory SyncAudioLikesBody.fromJson(Map<String, dynamic> json) => _$SyncAudioLikesBodyFromJson(json);
}
