import 'package:injectable/injectable.dart';

import 'spotify_access_token_provider.dart';
import 'spotify_creds_store.dart';

@LazySingleton(as: SpotifyAccessTokenProvider)
class SpotifyAccessTokenProviderImpl implements SpotifyAccessTokenProvider {
  SpotifyAccessTokenProviderImpl(
    this._spotifyCredsStore,
  );

  final SpotifyCredsStore _spotifyCredsStore;

  @override
  Future<String?> get() async {
    return _spotifyCredsStore.readAccessToken();
  }
}
