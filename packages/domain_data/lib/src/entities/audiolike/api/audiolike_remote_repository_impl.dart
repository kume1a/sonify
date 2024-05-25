import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';
import '../util/index.dart';
import 'audiolike_remote_repository.dart';

class AudioLikeRemoteRepositoryImpl implements AudioLikeRemoteRepository {
  AudioLikeRemoteRepositoryImpl(
    this._audioLikeRemoteService,
    this._audioLikeMapper,
  );

  final AudioLikeRemoteService _audioLikeRemoteService;
  final AudioLikeMapper _audioLikeMapper;

  @override
  Future<Either<NetworkCallError, AudioLike>> likeAudio({
    required String audioId,
  }) async {
    final res = await _audioLikeRemoteService.likeAudio(audioId: audioId);

    return res.map(_audioLikeMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, Unit>> unlikeAudio({
    required String audioId,
  }) {
    return _audioLikeRemoteService.unlikeAudio(audioId: audioId);
  }

  @override
  Future<Either<NetworkCallError, List<AudioLike>>> getAuthUserAudioLikes({
    List<String>? ids,
  }) async {
    final res = await _audioLikeRemoteService.getAuthUserAudioLikes(ids: ids);

    return res.map((r) => r.map(_audioLikeMapper.dtoToModel).toList());
  }
}
