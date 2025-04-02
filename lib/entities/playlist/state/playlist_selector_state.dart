import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';

@injectable
final class PlaylistSelectorCubit extends EntityLoaderCubit<List<UserPlaylist>> {
  PlaylistSelectorCubit(
    this._userPlaylistLocalRepository,
    this._authUserInfoProvider,
  ) {
    _init();
  }

  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  void _init() {
    loadEntityAndEmit();
  }

  @override
  Future<List<UserPlaylist>?> loadEntity() async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('PlaylistSelectorCubit: authUserId is null, cannot load playlists');
      return null;
    }

    final playlistsRes = await _userPlaylistLocalRepository.getAllByUserId(authUserId);

    return playlistsRes.dataOrNull;
  }
}
