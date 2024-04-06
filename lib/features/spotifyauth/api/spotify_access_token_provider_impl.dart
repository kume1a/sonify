import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import 'spotify_access_token_provider.dart';
import 'spotify_creds_store.dart';

@LazySingleton(as: SpotifyAccessTokenProvider)
class SpotifyAccessTokenProviderImpl implements SpotifyAccessTokenProvider {
  SpotifyAccessTokenProviderImpl(
    this._spotifyCredsStore,
    this._spotifyAuthRepository,
  );

  final SpotifyCredsStore _spotifyCredsStore;
  final SpotifyAuthRepository _spotifyAuthRepository;

  @override
  Future<String?> get() async {
    final spotifyRefreshToken = _spotifyCredsStore.readRefreshToken();

    if (spotifyRefreshToken != null) {
      await _spotifyAuthRepository.refreshSpotifyToken(spotifyRefreshToken: spotifyRefreshToken);
    }

    return _spotifyCredsStore.readAccessToken();
  }
}
