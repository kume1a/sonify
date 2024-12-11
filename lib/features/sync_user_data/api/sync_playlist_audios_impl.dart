import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../util/sync_entity_base.dart';
import 'sync_playlist_audios.dart';

@LazySingleton(as: SyncPlaylistAudios)
final class SyncPlaylistAudiosImpl extends SyncEntityBase implements SyncPlaylistAudios {
  SyncPlaylistAudiosImpl(
    this._playlistAudioRemoteRepository,
    this._playlistAudioLocalRepository,
    this._getAuthUserLocalPlaylistIds,
    this._saveLocalPlaylistAudioWithAudio,
  );

  final PlaylistAudioRemoteRepository _playlistAudioRemoteRepository;
  final PlaylistAudioLocalRepository _playlistAudioLocalRepository;
  final GetAuthUserLocalPlaylistIds _getAuthUserLocalPlaylistIds;
  final SaveLocalPlaylistAudioWithAudio _saveLocalPlaylistAudioWithAudio;

  @override
  Future<EmptyResult> deleteLocalEntities(List<String> ids) async {
    final res = await _playlistAudioLocalRepository.deleteByIds(ids);

    return res.toEmptyResult();
  }

  @override
  Future<EmptyResult> downloadEntities(List<String> ids) async {
    final playlistAudios = await _playlistAudioRemoteRepository.getAllByAuthUser(ids: ids);

    if (playlistAudios.isLeft) {
      return EmptyResult.err();
    }

    for (final playlistAudio in playlistAudios.rightOrThrow) {
      final res = await _saveLocalPlaylistAudioWithAudio(playlistAudio);

      if (res.isErr) {
        // TODO batch??
        Logger.root.info('failed to save playlistAudio with audio');
        return EmptyResult.err();
      }
    }

    return EmptyResult.success();
  }

  @override
  Future<List<String>?> getLocalEntityIds() async {
    final userPlaylistIds = await _getAuthUserLocalPlaylistIds();
    if (userPlaylistIds.isErr) {
      Logger.root.info('playlistIds is null, cannot get local entity ids');
      return null;
    }

    final res = await _playlistAudioLocalRepository.getAllByPlaylistIds(userPlaylistIds.dataOrThrow);

    return res.dataOrNull;
  }

  @override
  Future<List<String>?> getRemoteEntityIds() async {
    final playlistIds = await _playlistAudioRemoteRepository.getAllIdsByAuthUser();

    return playlistIds.rightOrNull;
  }
}
