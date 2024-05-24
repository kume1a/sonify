import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../util/sync_entity_base.dart';
import 'sync_playlists.dart';

@LazySingleton(as: SyncPlaylists)
final class SyncPlaylistsImpl extends SyncEntityBase implements SyncPlaylists {
  SyncPlaylistsImpl(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _playlistLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final playlists = await _playlistRemoteRepository.getAuthUserPlaylists(ids: ids);
    if (playlists.isLeft) {
      return EmptyResult.err();
    }

    return _playlistLocalRepository.bulkWrite(playlists.rightOrThrow);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final res = await _playlistLocalRepository.getAllIds();

    return res.dataOrNull;
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final playlistIds = await _playlistRemoteRepository.getAuthUserPlaylistIds();

    return playlistIds.rightOrNull;
  }
}
