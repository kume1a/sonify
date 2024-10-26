import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_playlists.dart';

@LazySingleton(as: SyncPlaylists)
final class SyncPlaylistsImpl extends FullSyncEntityBase implements SyncPlaylists {
  SyncPlaylistsImpl(
    this._userPlaylistRemoteRepository,
    this._playlistLocalRepository,
    this._getAuthUserLocalPlaylistIds,
  );

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;
  final GetAuthUserLocalPlaylistIds _getAuthUserLocalPlaylistIds;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _playlistLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities() async {
    final authUserPlaylists = await _userPlaylistRemoteRepository.getAllFullByAuthUser();

    if (authUserPlaylists.isLeft) {
      return EmptyResult.err();
    }

    final playlists = authUserPlaylists.rightOrThrow.map((e) => e.playlist).whereNotNull().toList();

    return _playlistLocalRepository.bulkWrite(playlists);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final authUserPlaylistIds = await _getAuthUserLocalPlaylistIds();
    if (authUserPlaylistIds.isErr) {
      Logger.root.info('playlistIds is null, cannot get local entity ids');
      return null;
    }

    return authUserPlaylistIds.dataOrThrow;
  }
}
