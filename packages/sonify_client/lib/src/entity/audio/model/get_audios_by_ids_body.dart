import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_audios_by_ids_body.g.dart';

part 'get_audios_by_ids_body.freezed.dart';

@freezed
class GetAudiosByIdsBody with _$GetAudiosByIdsBody {
  const factory GetAudiosByIdsBody({
    required List<String> audioIds,
  }) = _GetAudiosByIdsBody;

  factory GetAudiosByIdsBody.fromJson(Map<String, dynamic> json) => _$GetAudiosByIdsBodyFromJson(json);
}
