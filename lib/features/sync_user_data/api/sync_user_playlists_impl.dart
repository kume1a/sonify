import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../util/sync_entity_base.dart';
import 'sync_user_playlists.dart';

@LazySingleton(as: SyncUserPlaylists)
final class SyncUserPlaylistsImpl extends SyncEntityBase implements SyncUserPlaylists {
  SyncUserPlaylistsImpl(
    this._userPlaylistRemoteRepository,
    this._userPlaylistLocalRepository,
    this._authUserInfoProvider,
  );

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _userPlaylistLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final playlists = await _userPlaylistRemoteRepository.getAllByAuthUser(ids: ids);
    if (playlists.isLeft) {
      return EmptyResult.err();
    }

    return _userPlaylistLocalRepository.bulkWrite(playlists.rightOrThrow);
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      return null;
    }

    final res = await _userPlaylistLocalRepository.getAllIdsByUserId(userId);

    return res.dataOrNull;
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final playlistIds = await _userPlaylistRemoteRepository.getAllIdsByAuthUser();

    return playlistIds.rightOrNull;
  }
}
