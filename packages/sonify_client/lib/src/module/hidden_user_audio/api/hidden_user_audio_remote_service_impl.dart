import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/audio_id_body.dart';
import '../model/hidden_user_audio_dto.dart';
import 'hidden_user_audio_remote_service.dart';

class HiddenUserAudioRemoteServiceImpl with SafeHttpRequestWrap implements HiddenUserAudioRemoteService {
  HiddenUserAudioRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, HiddenUserAudioDto>> createForAuthUser({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdBody(audioId: audioId);

      return _apiClientProvider.get().hideUserAudioForAuthUser(body);
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdBody(audioId: audioId);

      await _apiClientProvider.get().unhideUserAudioForAuthUser(body);

      return unit;
    });
  }
}
