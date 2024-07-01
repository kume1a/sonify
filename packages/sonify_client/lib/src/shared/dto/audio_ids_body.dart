import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_ids_body.g.dart';

part 'audio_ids_body.freezed.dart';

@freezed
class AudioIdsBody with _$AudioIdsBody {
  const factory AudioIdsBody({
    required List<String> audioIds,
  }) = _AudioIdsBody;

  factory AudioIdsBody.fromJson(Map<String, dynamic> json) => _$AudioIdsBodyFromJson(json);
}
