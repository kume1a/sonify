import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/required_ids_body.dart';
import '../model/playlist_audio_dto.dart';

import 'playlist_audio_remote_service.dart';

class PlaylistAudioRemoteServiceImpl with SafeHttpRequestWrap implements PlaylistAudioRemoteService {
  PlaylistAudioRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, List<PlaylistAudioDto>>> getAllByAuthUser({
    required List<String> ids,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = RequiredIdsBody(ids: ids);

      final res = await _apiClientProvider.get().getPlaylistAudiosByAuthUser(body);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClientProvider.get().getPlaylistAudioIdsByAuthUser();

      return res ?? [];
    });
  }
}
