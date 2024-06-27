import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/spotify_refresh_token_payload.dart';
import '../model/spotify_search_result.dart';
import '../model/spotify_token_payload.dart';
import '../util/spotify_refresh_token_payload_mapper.dart';
import '../util/spotify_search_result_mapper.dart';
import '../util/spotify_token_payload_mapper.dart';
import 'spotify_remote_repository.dart';

class SpotifyRemoteRepositoryImpl implements SpotifyRemoteRepository {
  SpotifyRemoteRepositoryImpl(
    this._spotifyAuthRemoteService,
    this._spotifyTokenPayloadMapper,
    this._spotifyRefreshTokenPayloadMapper,
    this._spotifySearchResultMapper,
  );

  final SpotifyRemoteService _spotifyAuthRemoteService;
  final SpotifyTokenPayloadMapper _spotifyTokenPayloadMapper;
  final SpotifyRefreshTokenPayloadMapper _spotifyRefreshTokenPayloadMapper;
  final SpotifySearchResultMapper _spotifySearchResultMapper;

  @override
  Future<Either<NetworkCallError, SpotifyTokenPayload>> authorizeSpotify({
    required String code,
  }) async {
    final res = await _spotifyAuthRemoteService.authorizeSpotify(code: code);

    return res.map(_spotifyTokenPayloadMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, SpotifyRefreshTokenPayload>> refreshSpotifyToken({
    required String spotifyRefreshToken,
  }) async {
    final res = await _spotifyAuthRemoteService.refreshSpotifyToken(
      spotifyRefreshToken: spotifyRefreshToken,
    );

    return res.map(_spotifyRefreshTokenPayloadMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, SpotifySearchResult>> search({
    required String spotifyAccessToken,
    required String keyword,
  }) async {
    final res = await _spotifyAuthRemoteService.search(
      spotifyAccessToken: spotifyAccessToken,
      keyword: keyword,
    );

    return res.map(_spotifySearchResultMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyPlaylist({
    required String spotifyAccessToken,
    required String spotifyPlaylistId,
  }) {
    return _spotifyAuthRemoteService.importSpotifyPlaylist(
      spotifyAccessToken: spotifyAccessToken,
      spotifyPlaylistId: spotifyPlaylistId,
    );
  }

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  }) {
    return _spotifyAuthRemoteService.importSpotifyUserPlaylists(
      spotifyAccessToken: spotifyAccessToken,
    );
  }
}
