import 'package:injectable/injectable.dart';

import '../../../app/configuration/app_environment.dart';
import '../../../shared/values/constant.dart';
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
