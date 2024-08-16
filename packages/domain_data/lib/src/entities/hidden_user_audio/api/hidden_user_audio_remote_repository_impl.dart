import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/hidden_user_audio.dart';
import '../util/hidden_user_audio_mapper.dart';
import 'hidden_user_audio_remote_repository.dart';

class HiddenUserAudioRemoteRepositoryImpl implements HiddenUserAudioRemoteRepository {
  HiddenUserAudioRemoteRepositoryImpl(
    this._hiddenUserAudioRemoteService,
    this._hiddenUserAudioMapper,
  );

  final HiddenUserAudioRemoteService _hiddenUserAudioRemoteService;
  final HiddenUserAudioMapper _hiddenUserAudioMapper;

  @override
  Future<Either<NetworkCallError, HiddenUserAudio>> createForAuthUser({
    required String audioId,
  }) async {
    final res = await _hiddenUserAudioRemoteService.createForAuthUser(audioId: audioId);

    return res.map(_hiddenUserAudioMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  }) {
    return _hiddenUserAudioRemoteService.deleteForAuthUser(audioId: audioId);
  }
}
