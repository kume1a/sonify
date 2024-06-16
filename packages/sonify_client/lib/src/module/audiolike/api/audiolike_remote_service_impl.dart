import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/optional_ids_body.dart';
import '../model/audio_like_dto.dart';
import '../model/like_unlike_audio_body.dart';
import 'audiolike_remote_service.dart';

class AudioLikeRemoteServiceImpl with SafeHttpRequestWrap implements AudioLikeRemoteService {
  AudioLikeRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, AudioLikeDto>> likeAudio({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = LikeUnlikeAudioBody(audioId: audioId);

      return _apiClient.likeAudio(body);
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> unlikeAudio({required String audioId}) {
    return callCatchHandleNetworkCallError(() async {
      final body = LikeUnlikeAudioBody(audioId: audioId);

      await _apiClient.unlikeAudio(body);

      return unit;
    });
  }

  @override
  Future<Either<NetworkCallError, List<AudioLikeDto>>> getAuthUserAudioLikes({
    List<String>? ids,
  }) async {
    return callCatchHandleNetworkCallError(() async {
      final body = OptionalIdsBody(ids: ids);

      final res = await _apiClient.getAuthUserAudioLikes(body);

      return res ?? [];
    });
  }
}
