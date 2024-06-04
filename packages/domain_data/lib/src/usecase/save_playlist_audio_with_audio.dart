import 'package:common_models/common_models.dart';

import '../entities/audio/api/audio_local_repository.dart';
import '../entities/playlist_audio/api/playlist_audio_local_repository.dart';
import '../entities/playlist_audio/model/playlist_audio.dart';

class SavePlaylistAudioWithAudio {
  SavePlaylistAudioWithAudio(
    this._playlistAudioLocalRepository,
    this._audioLocalRepository,
  );

  final PlaylistAudioLocalRepository _playlistAudioLocalRepository;
  final AudioLocalRepository _audioLocalRepository;

  Future<Result<PlaylistAudio>> save(PlaylistAudio playlistAudio) async {
    if (playlistAudio.audio == null) {
      return Result.err();
    }

    final savedAudioRes = await _audioLocalRepository.save(playlistAudio.audio!);
    if (savedAudioRes.isErr) {
      return Result.err();
    }

    final savedAudio = savedAudioRes.dataOrThrow;

    final savedPlaylistAudio = await _playlistAudioLocalRepository.create(
      playlistAudio.copyWith(
        audioId: savedAudio.id,
        audio: savedAudio,
      ),
    );

    return savedPlaylistAudio;
  }
}
