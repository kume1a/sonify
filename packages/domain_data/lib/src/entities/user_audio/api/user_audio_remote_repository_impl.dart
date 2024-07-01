import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../audio/model/user_audio.dart';
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
    final res = await _userAudioRemoteService.createUserAudiosByAuthUser(audioIds: audioIds);

    return res.map((r) => r.map(_userAudioMapper.dtoToModel).toList());
  }
}
