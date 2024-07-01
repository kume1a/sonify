import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../entities/audio/api/audio_local_repository.dart';
import '../entities/audio/model/user_audio.dart';
import '../entities/user_audio/api/user_audio_local_repository.dart';

class SaveUserAudioWithAudio {
  SaveUserAudioWithAudio(
    this._userAudioLocalRepository,
    this._audioLocalRepository,
  );

  final UserAudioLocalRepository _userAudioLocalRepository;
  final AudioLocalRepository _audioLocalRepository;

  Future<Result<UserAudio>> save(UserAudio userAudio) async {
    if (userAudio.audio == null) {
      Logger.root.warning('SaveUserAudioWithAudio.save: userAudio.audio is null');
      return Result.err();
    }

    final savedAudioRes = await _audioLocalRepository.save(userAudio.audio!);
    if (savedAudioRes.isErr) {
      return Result.err();
    }

    final savedAudio = savedAudioRes.dataOrThrow;

    final savedUserAudio = await _userAudioLocalRepository.save(
      userAudio.copyWith(
        audioId: savedAudio.id,
        audio: savedAudio,
      ),
    );

    return savedUserAudio;
  }
}
