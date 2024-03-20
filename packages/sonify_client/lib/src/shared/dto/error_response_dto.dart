import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response_dto.g.dart';

part 'error_response_dto.freezed.dart';

@freezed
class ErrorResponseDto with _$ErrorResponseDto {
  const factory ErrorResponseDto({
    String? message,
    int? code,
  }) = _ErrorResponseDto;

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) => _$ErrorResponseDtoFromJson(json);
}
