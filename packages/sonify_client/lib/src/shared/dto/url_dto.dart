import 'package:freezed_annotation/freezed_annotation.dart';

part 'url_dto.g.dart';

part 'url_dto.freezed.dart';

@freezed
class UrlDto with _$UrlDto {
  const factory UrlDto({
    required String url,
  }) = _UrlDto;

  factory UrlDto.fromJson(Map<String, dynamic> json) => _$UrlDtoFromJson(json);
}
