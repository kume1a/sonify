import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/optional_ids_body.dart';
import '../model/create_user_playlist_body.dart';
import '../model/update_user_playlist_body.dart';
import '../model/user_playlist_dto.dart';
import 'user_playlist_remote_service.dart';

class UserPlaylistRemoteServiceImpl with SafeHttpRequestWrap implements UserPlaylistRemoteService {
  UserPlaylistRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllByAuthUser({
    required List<String>? ids,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = OptionalIdsBody(ids: ids);

      final res = await _apiClientProvider.get().getUserPlaylistsByAuthUser(body);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClientProvider.get().getUserPlaylistIdsByAuthUser();

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<UserPlaylistDto>>> getAllFullByAuthUser({
    required List<String>? playlistIds,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClientProvider.get().getUserPlaylistsFullByAuthUser(playlistIds);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllPlaylistIdsByAuthUser() {
    return callCatchHandleNetworkCallError(() async {
      final res = await _apiClientProvider.get().getPlaylistIdsByAuthUser();

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, UserPlaylistDto>> create({
    required String name,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = CreateUserPlaylistBody(name: name);

      return _apiClientProvider.get().createUserPlaylist(body);
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteById(String id) {
    return callCatchHandleNetworkCallError(() async {
      await _apiClientProvider.get().deleteUserPlaylistById(id);

      return unit;
    });
  }

  @override
  Future<Either<NetworkCallError, UserPlaylistDto>> updateById({
    required String id,
    required String? name,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = UpdateUserPlaylistBody(name: name);

      return _apiClientProvider.get().updateUserPlaylistById(id, body);
    });
  }
}
