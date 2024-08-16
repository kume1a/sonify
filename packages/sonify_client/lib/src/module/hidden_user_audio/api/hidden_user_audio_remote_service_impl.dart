import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/audio_id_body.dart';
import '../model/hidden_user_audio_dto.dart';
import 'hidden_user_audio_remote_service.dart';

class HiddenUserAudioRemoteServiceImpl with SafeHttpRequestWrap implements HiddenUserAudioRemoteService {
  HiddenUserAudioRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, HiddenUserAudioDto>> createForAuthUser({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdBody(audioId: audioId);

      return _apiClient.hideUserAudioForAuthUser(body);
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdBody(audioId: audioId);

      await _apiClient.unhideUserAudioForAuthUser(body);

      return unit;
    });
  }
}
