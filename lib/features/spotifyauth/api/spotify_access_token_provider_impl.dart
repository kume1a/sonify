import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../entities/server_time/api/get_server_time.dart';
import 'spotify_access_token_provider.dart';
import 'spotify_creds_store.dart';

@LazySingleton(as: SpotifyAccessTokenProvider)
class SpotifyAccessTokenProviderImpl implements SpotifyAccessTokenProvider {
  SpotifyAccessTokenProviderImpl(
    this._spotifyCredsStore,
    this._spotifyAuthRemoteRepository,
    this._getServerTime,
  );

  final SpotifyCredsStore _spotifyCredsStore;
  final SpotifyRemoteRepository _spotifyAuthRemoteRepository;
  final GetServerTime _getServerTime;

  @override
  Future<String?> get() async {
    final spotifyAccessTokenExpiresAt = _spotifyCredsStore.readTokenExpiresAt();
    if (spotifyAccessTokenExpiresAt == null) {
      return null;
    }

    final serverTime = await _getServerTime();
    final isSpotifyAccessTokenExpired = spotifyAccessTokenExpiresAt.difference(serverTime).inSeconds < 60;

    if (!isSpotifyAccessTokenExpired) {
      return _spotifyCredsStore.readAccessToken();
    }

    final spotifyRefreshToken = _spotifyCredsStore.readRefreshToken();
    if (spotifyRefreshToken == null) {
      return null;
    }

    Logger.root.finer('Refreshing Spotify token...');

    return _spotifyAuthRemoteRepository
        .refreshSpotifyToken(spotifyRefreshToken: spotifyRefreshToken)
        .awaitFold(
      (l) => null,
      (r) async {
        final newServerTime = await _getServerTime();
        final newExpiresAt = newServerTime.add(Duration(seconds: r.expiresIn));

        await Future.wait([
          _spotifyCredsStore.writeAccessToken(r.accessToken),
          _spotifyCredsStore.writeTokenExpiresAt(newExpiresAt),
        ]);

        return r.accessToken;
      },
    );
  }
}
