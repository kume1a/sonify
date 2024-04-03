import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import 'playlist_repository.dart';

class PlaylistRepositoryImpl with SafeHttpRequestWrap implements PlaylistRepository {
  PlaylistRepositoryImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<FetchFailure, Unit>> importSpotifyUserPlaylists({
    required String spotifyAccessToken,
  }) {
    return callCatchWithFetchFailure(
      () async {
        await _apiClient.importSpotifyUserPlaylists(
          spotifyAccessToken,
        );

        return unit;
      },
    );
  }
}
