import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/optional_ids_body.dart';
import '../model/user_playlist_dto.dart';
import 'user_playlist_remote_service.dart';

class UserPlaylistRemoteServiceImpl with SafeHttpRequestWrap implements UserPlaylistRemoteService {
  UserPlaylistRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllByAuthUser({
    required List<String>? ids,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = OptionalIdsBody(ids: ids);

      final res = await _apiClient.getUserPlaylistsByAuthUser(body);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getUserPlaylistIdsByAuthUser();

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllFullByAuthUser({
    required List<String>? playlistIds,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getUserPlaylistsFullByAuthUser(playlistIds);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllPlaylistIdsByAuthUser() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClient.getPlaylistIdsByAuthUser();

      return res ?? [];
    });
  }
}
