import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/index.dart';
import 'playlist_remote_service.dart';

class PlaylistRemoteServiceImpl with SafeHttpRequestWrap implements PlaylistRemoteService {
  PlaylistRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<ActionFailure, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  }) {
    return callCatchWithActionFailure(
      () async {
        await _apiClient.importSpotifyUserPlaylists(
          spotifyAccessToken,
        );

        return unit;
      },
    );
  }

  @override
  Future<Either<FetchFailure, List<PlaylistDto>>> getAuthUserPlaylists() {
    return callCatchWithFetchFailure(
      () => _apiClient.getAuthUserPlaylists(),
    );
  }

  @override
  Future<Either<FetchFailure, PlaylistDto>> getPlaylistById({
    required String playlistId,
  }) {
    return callCatchWithFetchFailure(() => _apiClient.getPlaylistById(playlistId));
  }
}
