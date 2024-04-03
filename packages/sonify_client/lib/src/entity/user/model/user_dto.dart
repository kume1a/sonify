import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';

part 'user_dto.freezed.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    String? id,
    String? createdAt,
    String? name,
    String? email,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
