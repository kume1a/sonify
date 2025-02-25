import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/user_audio.dart';
import '../util/user_audio_mapper.dart';
import 'user_audio_remote_repository.dart';

class UserAudioRemoteRepositoryImpl implements UserAudioRemoteRepository {
  UserAudioRemoteRepositoryImpl(
    this._userAudioRemoteService,
    this._userAudioMapper,
  );

  final UserAudioRemoteService _userAudioRemoteService;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Either<NetworkCallError, List<UserAudio>>> createManyForAuthUser({
    required List<String> audioIds,
  }) async {
    final res = await _userAudioRemoteService.createForAuthUser(audioIds: audioIds);

    return res.map((r) => r.map(_userAudioMapper.dtoToModel).toList());
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  }) {
    return _userAudioRemoteService.deleteForAuthUser(audioId: audioId);
  }

  @override
  Future<Either<NetworkCallError, List<String>>> getAuthUserAudioIds() {
    return _userAudioRemoteService.getAuthUserAudioIds();
  }

  @override
  Future<Either<NetworkCallError, List<UserAudio>>> getAuthUserAudiosByAudioIds(
    List<String> audioIds,
  ) async {
    final res = await _userAudioRemoteService.getAuthUserAudiosByAudioIds(audioIds);

    return res.map((r) => r.map(_userAudioMapper.dtoToModel).toList());
  }
}
