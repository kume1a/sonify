import 'package:injectable/injectable.dart';

import '../../../app/configuration/app_environment.dart';
import 'spotify_api.dart';

@LazySingleton(as: SpotifyApi)
class SpotifyApiImpl implements SpotifyApi {
  @override
  Uri getAuthorizationUrl() {
    const scopes = [
      'user-read-private',
      'user-read-email',
      'playlist-read-private',
      'playlist-read-collaborative',
    ];

    const redirectUrl = 'app://sonify/spotifyauth';

    final uri = Uri.https(
      'accounts.spotify.com',
      '/authorize',
      {
        'response_type': 'code',
        'client_id': AppEnvironment.spotifyClientId,
        'scope': scopes.join('%20'),
        'redirect_uri': redirectUrl,
      },
    );

    return uri;
  }
}
