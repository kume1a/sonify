import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_id_body.g.dart';

part 'audio_id_body.freezed.dart';

@freezed
class AudioIdBody with _$AudioIdBody {
  const factory AudioIdBody({
    required String audioId,
  }) = _AudioIdBody;

  factory AudioIdBody.fromJson(Map<String, dynamic> json) => _$AudioIdBodyFromJson(json);
}
