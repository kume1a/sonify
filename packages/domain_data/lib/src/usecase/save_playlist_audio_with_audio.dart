import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

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
      Logger.root.info('SavePlaylistAudioWithAudio.save: playlistAudio.audio is null');
      return Result.err();
    }

    final savedAudioRes = await _audioLocalRepository.save(playlistAudio.audio!);
    if (savedAudioRes.isErr) {
      Logger.root.info('SavePlaylistAudioWithAudio.save: savedAudioRes.isErr');
      return Result.err();
    }

    final savedAudio = savedAudioRes.dataOrThrow;
    if (savedAudio.id == null) {
      Logger.root.info('SavePlaylistAudioWithAudio.save: savedAudio.id is null');
      return Result.err();
    }

    final savedPlaylistAudio = await _playlistAudioLocalRepository.create(
      playlistAudio.copyWith(
        audioId: savedAudio.id!,
        audio: savedAudio,
      ),
    );

    return savedPlaylistAudio;
  }
}
