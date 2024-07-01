import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_body.g.dart';

part 'update_user_body.freezed.dart';

@freezed
class UpdateUserBody with _$UpdateUserBody {
  const factory UpdateUserBody({
    required String? name,
  }) = _UpdateUserBody;

  factory UpdateUserBody.fromJson(Map<String, dynamic> json) => _$UpdateUserBodyFromJson(json);
}
