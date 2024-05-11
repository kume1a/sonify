import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_user_playlists.dart';

@LazySingleton(as: SyncUserPlaylists)
final class SyncUserPlaylistsImpl extends SyncEntityBase implements SyncUserPlaylists {
  SyncUserPlaylistsImpl(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
    this._authUserInfoProvider,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('sync playlists, authUserId is null');
      return EmptyResult.err();
    }

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
    final audioLikes = await _playlistRemoteRepository.getAuthUserPlaylistIds();

    return audioLikes.rightOrNull;
  }
}
