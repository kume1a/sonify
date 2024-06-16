import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_unlike_audio_body.g.dart';

part 'like_unlike_audio_body.freezed.dart';

@freezed
class LikeUnlikeAudioBody with _$LikeUnlikeAudioBody {
  const factory LikeUnlikeAudioBody({
    required String audioId,
  }) = _LikeUnlikeAudioBody;

  factory LikeUnlikeAudioBody.fromJson(Map<String, dynamic> json) => _$LikeUnlikeAudioBodyFromJson(json);
}
