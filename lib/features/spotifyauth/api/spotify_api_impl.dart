import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/values/constant.dart';
import 'spotify_api.dart';

@LazySingleton(as: SpotifyApi)
class SpotifyApiImpl implements SpotifyApi {
  SpotifyApiImpl();

  @override
  Uri getAuthorizationUrl() {
    const scopes = [
      'user-read-private',
      'user-read-email',
      'playlist-read-private',
      'playlist-read-collaborative',
    ];

    final uri = Uri.https(
      'accounts.spotify.com',
      '/authorize',
      {
        'response_type': 'code',
        'client_id': AppEnvironment.spotifyClientId,
        'scope': scopes.join('%20'),
        'redirect_uri': kSpotifyCallbackUrl,
      },
    );

    return uri;
  }
}
