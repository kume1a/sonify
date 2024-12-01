import 'package:common_models/common_models.dart';

import '../model/playlist_audio.dart';

abstract interface class PlaylistAudioLocalRepository {
  Future<Result<PlaylistAudio>> create(PlaylistAudio playlistAudios);

  Future<EmptyResult> batchCreate(List<PlaylistAudio> playlistAudios);

  Future<Result<int>> deleteByIds(List<String> ids);

  Future<EmptyResult> deleteById(String id);

  Future<Result<List<PlaylistAudio>>> getAll();

  Future<Result<List<String>>> getAllByPlaylistIds(List<String> playlistIds);

  Future<Result<List<PlaylistAudio>>> getAllWithAudios({
    required String playlistId,
    String? searchQuery,
  });
}
