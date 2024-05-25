import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';

import '../../../api/api_client.dart';
import '../model/index.dart';
import 'playlist_remote_service.dart';

class PlaylistRemoteServiceImpl with SafeHttpRequestWrap implements PlaylistRemoteService {
  PlaylistRemoteServiceImpl(
    this._apiClient,
    this._dio,
  );

  final ApiClient _apiClient;
  final Dio _dio;

  @override
  Future<Either<NetworkCallError, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  }) {
    const timeout = Duration(minutes: 2, seconds: 30);

    return callCatchHandleNetworkCallError(
      () async {
        await _dio.fetch<Map<String, dynamic>>(
          Options(
            method: 'POST',
            responseType: ResponseType.json,
            sendTimeout: timeout,
            receiveTimeout: timeout,
          ).compose(
            _dio.options,
            '/v1/spotify/importUserPlaylists',
            queryParameters: {
              'spotifyAccessToken': spotifyAccessToken,
            },
          ),
        );

        return unit;
      },
    );
  }

  @override
  Future<Either<NetworkCallError, List<PlaylistDto>>> getAuthUserPlaylists({
    required List<String>? ids,
  }) {
    return callCatchHandleNetworkCallError(
      () async {
        final res = await _apiClient.getAuthUserPlaylists(ids);

        return res ?? [];
      },
    );
  }

  @override
  Future<Either<NetworkCallError, PlaylistDto>> getPlaylistById({
    required String playlistId,
  }) {
    return callCatchHandleNetworkCallError(() => _apiClient.getPlaylistById(playlistId));
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAuthUserPlaylistIds() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getAuthUserPlaylistIds();

      return res ?? [];
    });
  }
}
