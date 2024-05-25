import 'package:common_models/common_models.dart';

import '../model/playlist_audio.dart';

abstract interface class PlaylistAudioLocalRepository {
  Future<EmptyResult> batchCreate(List<PlaylistAudio> playlistAudios);

  Future<EmptyResult> deleteByIds(List<String> ids);

  Future<Result<List<PlaylistAudio>>> getAll();
}
