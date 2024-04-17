import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/authorize_spotify_body.dart';
import '../model/refresh_spotify_token_body.dart';
import '../model/spotify_refresh_token_payload_dto.dart';
import '../model/spotify_token_payload_dto.dart';
import 'spotify_auth_remote_service.dart';

class SpotifyAuthRemoteServiceImpl with SafeHttpRequestWrap implements SpotifyAuthRemoteService {
  SpotifyAuthRemoteServiceImpl(
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
}
