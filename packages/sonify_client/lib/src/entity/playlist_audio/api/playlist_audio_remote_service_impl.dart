import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/playlist_audio_dto.dart';

import 'playlist_audio_remote_service.dart';

class PlaylistAudioRemoteServiceImpl with SafeHttpRequestWrap implements PlaylistAudioRemoteService {
  PlaylistAudioRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, List<PlaylistAudioDto>>> getAll({
    required List<String> ids,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getAllPlaylistAudios(ids);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUserPlaylists() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getAllPlaylistAudioIdsByAuthUserPlaylists();

      return res ?? [];
    });
  }
}
