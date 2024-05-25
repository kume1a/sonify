import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_audio_likes_body.g.dart';

part 'get_audio_likes_body.freezed.dart';

@freezed
class GetAudioLikesBody with _$GetAudioLikesBody {
  const factory GetAudioLikesBody({
    required List<String>? ids,
  }) = _GetAudioLikesBody;

  factory GetAudioLikesBody.fromJson(Map<String, dynamic> json) => _$GetAudioLikesBodyFromJson(json);
}
