import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../model/index.dart';
import 'playlist_remote_service.dart';

class PlaylistRemoteServiceImpl with SafeHttpRequestWrap implements PlaylistRemoteService {
  PlaylistRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, PlaylistDto>> getPlaylistById({
    required String playlistId,
  }) {
    return callCatchHandleNetworkCallError(
      () => _apiClientProvider.get().getPlaylistById(playlistId),
    );
  }
}
