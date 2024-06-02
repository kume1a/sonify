import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/playlist_audio.dart';
import '../util/playlist_audio_mapper.dart';
import 'playlist_audio_remote_repository.dart';

class PlaylistAudioRemoteRepositoryImpl implements PlaylistAudioRemoteRepository {
  PlaylistAudioRemoteRepositoryImpl(
    this._playlistAudioRemoteService,
    this._playlistAudioMapper,
  );

  final PlaylistAudioRemoteService _playlistAudioRemoteService;
  final PlaylistAudioMapper _playlistAudioMapper;

  @override
  Future<Either<NetworkCallError, List<PlaylistAudio>>> getAll({
    required List<String> ids,
  }) async {
    final res = await _playlistAudioRemoteService.getAllByAuthUser(ids: ids);

    return res.map(_playlistAudioMapper.dtoListToModel);
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUserPlaylists() {
    return _playlistAudioRemoteService.getAllIdsByAuthUserPlaylists();
  }
}
