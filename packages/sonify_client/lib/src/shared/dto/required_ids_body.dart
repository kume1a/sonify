import 'package:freezed_annotation/freezed_annotation.dart';

part 'required_ids_body.g.dart';

part 'required_ids_body.freezed.dart';

@freezed
class RequiredIdsBody with _$RequiredIdsBody {
  const factory RequiredIdsBody({
    required List<String> ids,
  }) = _RequiredIdsBody;

  factory RequiredIdsBody.fromJson(Map<String, dynamic> json) => _$RequiredIdsBodyFromJson(json);
}
