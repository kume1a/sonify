import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../entities/playlist/api/playlist_local_repository.dart';
import '../entities/user_playlist/api/user_playlist_local_repository.dart';
import '../entities/user_playlist/model/user_playlist.dart';

class SaveUserPlaylistWithPlaylist {
  SaveUserPlaylistWithPlaylist(
    this._userPlaylistLocalRepository,
    this._playlistLocalRepository,
  );

  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final PlaylistLocalRepository _playlistLocalRepository;

  Future<Result<UserPlaylist>> save(UserPlaylist userPlaylist) async {
    if (userPlaylist.playlist == null) {
      Logger.root.info('SaveUserPlaylistWithPlaylist.save: userPlaylist.playlist is null');
      return Result.err();
    }

    final savedPlaylistRes = await _playlistLocalRepository.create(userPlaylist.playlist!);
    if (savedPlaylistRes.isErr) {
      Logger.root.info('SaveUserPlaylistWithPlaylist.save: savedPlaylistRes.isErr');
      return Result.err();
    }

    final savedPlaylist = savedPlaylistRes.dataOrThrow;

    final savedUserPlaylist = await _userPlaylistLocalRepository.create(
      userPlaylist.copyWith(
        playlistId: savedPlaylist.id,
        playlist: savedPlaylist,
      ),
    );

    return savedUserPlaylist;
  }
}
