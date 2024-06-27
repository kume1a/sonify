import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/authorize_spotify_body.dart';
import '../model/import_spotify_playlist_body.dart';
import '../model/refresh_spotify_token_body.dart';
import '../model/spotify_access_token_body.dart';
import '../model/spotify_refresh_token_payload_dto.dart';
import '../model/spotify_search_result_dto.dart';
import '../model/spotify_token_payload_dto.dart';
import 'spotify_remote_service.dart';

class SpotifyRemoteServiceImpl with SafeHttpRequestWrap implements SpotifyRemoteService {
  SpotifyRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, SpotifyTokenPayloadDto>> authorizeSpotify({
    required String code,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = AuthorizeSpotifyBody(code: code);

      return _apiClient.authorizeSpotify(body);
    });
  }

  @override
  Future<Either<NetworkCallError, SpotifyRefreshTokenPayloadDto>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  }) async {
    return callCatchHandleNetworkCallError(() {
      final body = RefreshSpotifyTokenBody(spotifyRefreshToken: spotifyRefreshToken);

      return _apiClient.refreshSpotifyToken(body);
    });
  }

  @override
  Future<Either<NetworkCallError, SpotifySearchResultDto>> search({
    required String spotifyAccessToken,
    required String keyword,
  }) {
    return callCatchHandleNetworkCallError(() => _apiClient.spotifySearch(keyword, spotifyAccessToken));
  }

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({required String spotifyAccessToken}) {
    return callCatchHandleNetworkCallError(() async {
      final body = SpotifyAccessTokenBody(
        spotifyAccessToken: spotifyAccessToken,
      );

      await _apiClient.importSpotifyUserPlaylists(body);

      return unit;
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyPlaylist(
      {required String spotifyAccessToken, required String spotifyPlaylistId}) {
    return callCatchHandleNetworkCallError(() async {
      final body = ImportSpotifyPlaylistBody(
        spotifyAccessToken: spotifyAccessToken,
        spotifyPlaylistId: spotifyPlaylistId,
      );

      await _apiClient.importSpotifyPlaylist(body);

      return unit;
    });
  }
}
