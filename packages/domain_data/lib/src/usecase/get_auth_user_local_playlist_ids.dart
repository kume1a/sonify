import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../entities/user_playlist/api/user_playlist_local_repository.dart';
import '../feature/auth/api/auth_user_info_provider.dart';

class GetAuthUserLocalPlaylistIds {
  GetAuthUserLocalPlaylistIds(
    this._authUserInfoProvider,
    this._userPlaylistLocalRepository,
  );

  final AuthUserInfoProvider _authUserInfoProvider;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;

  Future<Result<List<String>>> call() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('authUserId is null, cannot get local entity ids');
      return Result.err();
    }

    final userPlaylists = await _userPlaylistLocalRepository.getAllByUserId(authUserId);
    if (userPlaylists.isErr) {
      Logger.root.info('playlistIds is null, cannot get local entity ids');
      return Result.err();
    }

    final authUserPlaylistIds = userPlaylists.dataOrThrow.map((e) => e.playlistId).whereNotNull().toList();

    return Result.success(authUserPlaylistIds);
  }
}
