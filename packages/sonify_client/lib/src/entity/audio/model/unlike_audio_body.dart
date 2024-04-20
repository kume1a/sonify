import 'package:freezed_annotation/freezed_annotation.dart';

part 'unlike_audio_body.g.dart';

part 'unlike_audio_body.freezed.dart';

@freezed
class UnlikeAudioBody with _$UnlikeAudioBody {
  const factory UnlikeAudioBody({
    required String audioId,
  }) = _UnlikeAudioBody;

  factory UnlikeAudioBody.fromJson(Map<String, dynamic> json) => _$UnlikeAudioBodyFromJson(json);
}
