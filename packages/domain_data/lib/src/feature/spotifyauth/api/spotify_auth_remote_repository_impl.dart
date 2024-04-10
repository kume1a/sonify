import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/spotify_refresh_token_payload.dart';
import '../model/spotify_token_payload.dart';
import '../util/spotify_refresh_token_payload_mapper.dart';
import '../util/spotify_token_payload_mapper.dart';
import 'spotify_auth_remote_repository.dart';

class SpotifyAuthRemoteRepositoryImpl implements SpotifyAuthRemoteRepository {
  SpotifyAuthRemoteRepositoryImpl(
    this._spotifyAuthRemoteService,
    this._spotifyTokenPayloadMapper,
    this._spotifyRefreshTokenPayloadMapper,
  );

  final SpotifyAuthRemoteService _spotifyAuthRemoteService;
  final SpotifyTokenPayloadMapper _spotifyTokenPayloadMapper;
  final SpotifyRefreshTokenPayloadMapper _spotifyRefreshTokenPayloadMapper;

  @override
  Future<Either<ActionFailure, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  }) async {
    final res = await _spotifyAuthRemoteService.authorizeSpotify(code: code);

    return res.map(_spotifyTokenPayloadMapper.dtoToModel);
  }

  @override
  Future<Either<ActionFailure, SpotifyRefreshTokenPayload>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  }) async {
    final res = await _spotifyAuthRemoteService.refreshSpotifyToken(
      spotifyRefreshToken: spotifyRefreshToken,
    );

    return res.map(_spotifyRefreshTokenPayloadMapper.dtoToModel);
  }
}
