abstract interface class SpotifyCredsStore {
  String? readAccessToken();

  String? readRefreshToken();

  DateTime? readTokenExpiry();

  Future<void> writeRefreshToken(String token);

  Future<void> writeAccessToken(String token);

  Future<void> writeTokenExpiresIn(int expiresInSeconds);

  Future<void> clear();
}
