import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/authorize_spotify_body.dart';
import '../model/refresh_spotify_token_body.dart';
import '../model/spotify_refresh_token_payload.dart';
import '../model/spotify_token_payload.dart';
import '../util/spotify_refresh_token_payload_mapper.dart';
import '../util/spotify_token_payload_mapper.dart';
import 'spotify_auth_repository.dart';

class SpotifyAuthRepositoryImpl with SafeHttpRequestWrap implements SpotifyAuthRepository {
  SpotifyAuthRepositoryImpl(
    this._apiClient,
    this._spotifyTokenPayloadMapper,
    this._spotifyRefreshTokenPayloadMapper,
  );

  final ApiClient _apiClient;
  final SpotifyTokenPayloadMapper _spotifyTokenPayloadMapper;
  final SpotifyRefreshTokenPayloadMapper _spotifyRefreshTokenPayloadMapper;

  @override
  Future<Either<ActionFailure, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  }) {
    return callCatchWithActionFailure(() async {
      final body = AuthorizeSpotifyBody(code: code);

      final dto = await _apiClient.authorizeSpotify(body);

      return _spotifyTokenPayloadMapper.dtoToModel(dto);
    });
  }

  @override
  Future<Either<ActionFailure, SpotifyRefreshTokenPayload>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  }) async {
    return callCatchWithActionFailure(() async {
      final body = RefreshSpotifyTokenBody(spotifyRefreshToken: spotifyRefreshToken);

      final res = await _apiClient.refreshSpotifyToken(body);

      return _spotifyRefreshTokenPayloadMapper.dtoToModel(res);
    });
  }
}
