import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_audio_body.g.dart';

part 'like_audio_body.freezed.dart';

@freezed
class LikeAudioBody with _$LikeAudioBody {
  const factory LikeAudioBody({
    required String audioId,
  }) = _LikeAudioBody;

  factory LikeAudioBody.fromJson(Map<String, dynamic> json) => _$LikeAudioBodyFromJson(json);
}
