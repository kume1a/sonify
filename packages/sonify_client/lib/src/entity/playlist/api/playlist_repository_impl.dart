import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../model/playlist.dart';
import '../util/playlist_mapper.dart';
import 'playlist_repository.dart';

class PlaylistRepositoryImpl with SafeHttpRequestWrap implements PlaylistRepository {
  PlaylistRepositoryImpl(
    this._apiClient,
    this._playlistMapper,
  );

  final ApiClient _apiClient;
  final PlaylistMapper _playlistMapper;

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

  @override
  Future<Either<FetchFailure, List<Playlist>>> getAuthUserPlaylists() {
    return callCatchWithFetchFailure(
      () async {
        final res = await _apiClient.getAuthUserPlaylists();

        return mapListOrEmpty(res, _playlistMapper.dtoToModel);
      },
    );
  }
}
