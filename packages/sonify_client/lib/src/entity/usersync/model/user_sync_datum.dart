import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_sync_datum.freezed.dart';

@freezed
class UserSyncDatum with _$UserSyncDatum {
  const factory UserSyncDatum({
    required String id,
    required String userId,
    required DateTime? spotifyLastSyncedAt,
  }) = _UserSyncDatum;
}
