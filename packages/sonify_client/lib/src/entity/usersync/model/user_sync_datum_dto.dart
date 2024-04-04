import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_sync_datum_dto.g.dart';

part 'user_sync_datum_dto.freezed.dart';

@freezed
class UserSyncDatumDto with _$UserSyncDatumDto {
  const factory UserSyncDatumDto({
    String? id,
    String? userId,
    String? spotifyLastSyncedAt,
  }) = _UserSyncDatumDto;

  factory UserSyncDatumDto.fromJson(Map<String, dynamic> json) => _$UserSyncDatumDtoFromJson(json);
}
