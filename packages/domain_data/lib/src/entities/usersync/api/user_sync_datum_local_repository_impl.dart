import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_sync_datum.dart';
import 'user_sync_datum_local_repository.dart';

class UserSyncDatumLocalRepositoryImpl with ResultWrap implements UserSyncDatumLocalRepository {
  UserSyncDatumLocalRepositoryImpl(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  static const _keyId = 'auth_user_sync_datum_id';
  static const _keyUserId = 'auth_user_sync_datum_user_id';
  static const _keySpotifyLastSyncedAt = 'auth_user_sync_datum_spotify_last_synced_at';

  @override
  Future<Result<UserSyncDatum?>> getAuthUserSyncDatum() {
    return wrapWithResult(() {
      final id = _sharedPreferences.getString(_keyId);
      final userId = _sharedPreferences.getString(_keyUserId);
      final spotifyLastSyncedAtMillis = _sharedPreferences.getInt(_keySpotifyLastSyncedAt);

      if (id == null || userId == null) {
        return Future.value();
      }

      return Future.value(
        UserSyncDatum(
          id: id,
          userId: userId,
          spotifyLastSyncedAt: tryMapDateMillis(spotifyLastSyncedAtMillis),
        ),
      );
    });
  }

  @override
  Future<EmptyResult> writeAuthUserSyncDatum(UserSyncDatum userSyncDatum) {
    return wrapWithEmptyResult(() {
      return Future.wait([
        _sharedPreferences.setString(_keyId, userSyncDatum.id),
        _sharedPreferences.setString(_keyUserId, userSyncDatum.userId),
        if (userSyncDatum.spotifyLastSyncedAt != null)
          _sharedPreferences.setInt(
            _keySpotifyLastSyncedAt,
            userSyncDatum.spotifyLastSyncedAt!.millisecondsSinceEpoch,
          ),
      ]);
    });
  }

  @override
  Future<EmptyResult> clear() {
    return wrapWithEmptyResult(() {
      return Future.wait([
        _sharedPreferences.remove(_keyId),
        _sharedPreferences.remove(_keyUserId),
        _sharedPreferences.remove(_keySpotifyLastSyncedAt),
      ]);
    });
  }
}
