import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_time_dto.g.dart';

part 'server_time_dto.freezed.dart';

@freezed
class ServerTimeDto with _$ServerTimeDto {
  const factory ServerTimeDto({
    String? time,
  }) = _ServerTimeDto;

  factory ServerTimeDto.fromJson(Map<String, dynamic> json) => _$ServerTimeDtoFromJson(json);
}
