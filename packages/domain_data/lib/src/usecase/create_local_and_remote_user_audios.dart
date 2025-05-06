import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../entities/user_audio/api/user_audio_local_repository.dart';
import '../entities/user_audio/api/user_audio_remote_repository.dart';

class CreateAndLocalRemoteUserAudios {
  CreateAndLocalRemoteUserAudios(
    this._userAudioRemoteRepository,
    this._userAudioLocalRepository,
  );

  final UserAudioRemoteRepository _userAudioRemoteRepository;
  final UserAudioLocalRepository _userAudioLocalRepository;

  Future<EmptyResult> createManyForAuthUser({
    required List<String> audioIds,
  }) async {
    final remoteRes = await _userAudioRemoteRepository.createManyForAuthUser(audioIds: audioIds);

    if (remoteRes.isLeft) {
      Logger.root.info('CreateLocalRemoteUserAudiosUseCase.execute: remote user audios create failed');
      return EmptyResult.err();
    }

    final remoteUserAudios = remoteRes.rightOrThrow;
    if (remoteUserAudios.isEmpty) {
      Logger.root
          .warning('CreateLocalRemoteUserAudiosUseCase.execute: user audios created but result is empty');
      return EmptyResult.err();
    }

    final localRes = await _userAudioLocalRepository.createMany(remoteUserAudios);
    if (localRes.isErr) {
      Logger.root.info('CreateLocalRemoteUserAudiosUseCase.execute: local user audios create failed');
      return EmptyResult.err();
    }

    return EmptyResult.success();
  }
}
