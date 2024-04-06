abstract interface class SpotifyCredsStore {
  String? readAccessToken();

  String? readRefreshToken();

  DateTime? readTokenExpiresAt();

  Future<void> writeRefreshToken(String token);

  Future<void> writeAccessToken(String token);

  Future<void> writeTokenExpiresAt(DateTime expiresAt);

  Future<void> clear();
}
