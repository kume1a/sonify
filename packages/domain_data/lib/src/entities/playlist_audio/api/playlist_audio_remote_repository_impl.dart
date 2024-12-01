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
  Future<Either<NetworkCallError, List<PlaylistAudio>>> getAllByAuthUser({
    required List<String> ids,
  }) async {
    final res = await _playlistAudioRemoteService.getAllByAuthUser(ids: ids);

    return res.map(_playlistAudioMapper.dtoListToModel);
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAllIdsByAuthUser() {
    return _playlistAudioRemoteService.getAllIdsByAuthUser();
  }

  @override
  Future<Either<NetworkCallError, PlaylistAudio>> create({
    required String playlistId,
    required String audioId,
  }) async {
    final res = await _playlistAudioRemoteService.create(playlistId: playlistId, audioId: audioId);

    return res.map(_playlistAudioMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteByPlaylistIdAndAudioId({
    required String playlistId,
    required String audioId,
  }) {
    return _playlistAudioRemoteService.deleteByPlaylistIdAndAudioId(
      playlistId: playlistId,
      audioId: audioId,
    );
  }
}
