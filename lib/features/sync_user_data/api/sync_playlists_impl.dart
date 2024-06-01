import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../util/sync_entity_base.dart';
import 'sync_playlists.dart';

@LazySingleton(as: SyncPlaylists)
final class SyncPlaylistsImpl extends SyncEntityBase implements SyncPlaylists {
  SyncPlaylistsImpl(
    this._userPlaylistRemoteRepository,
    this._playlistLocalRepository,
  );

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _playlistLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final authUserPlaylists = await _userPlaylistRemoteRepository.getAllFullByAuthUser(
      playlistIds: ids,
    );

    if (authUserPlaylists.isLeft) {
      return EmptyResult.err();
    }

    final playlists = authUserPlaylists.rightOrThrow.map((e) => e.playlist).whereNotNull().toList();

    return _playlistLocalRepository.bulkWrite(playlists);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final res = await _playlistLocalRepository.getAllIds();

    return res.dataOrNull;
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final playlistIds = await _userPlaylistRemoteRepository.getAllPlaylistIdsByAuthUser();

    return playlistIds.rightOrNull;
  }
}
