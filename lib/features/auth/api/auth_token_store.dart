abstract interface class AuthTokenStore {
  Future<void> writeAccessToken(String accessToken);

  Future<String?> readAccessToken();

  Future<bool> hasAccessToken();

  Future<void> clear();
}
