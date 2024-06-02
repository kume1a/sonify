import 'package:freezed_annotation/freezed_annotation.dart';

part 'optional_ids_body.g.dart';

part 'optional_ids_body.freezed.dart';

@freezed
class OptionalIdsBody with _$OptionalIdsBody {
  const factory OptionalIdsBody({
    required List<String>? ids,
  }) = _OptionalIdsBody;

  factory OptionalIdsBody.fromJson(Map<String, dynamic> json) => _$OptionalIdsBodyFromJson(json);
}
