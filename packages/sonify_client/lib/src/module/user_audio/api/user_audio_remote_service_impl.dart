import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/audio_ids_body.dart';
import '../model/user_audio_dto.dart';
import 'user_audio_remote_service.dart';

class UserAudioRemoteServiceImpl with SafeHttpRequestWrap implements UserAudioRemoteService {
  UserAudioRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<NetworkCallError, List<UserAudioDto>>> createUserAudiosByAuthUser({
    required List<String> audioIds,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdsBody(audioIds: audioIds);

      final res = await _apiClient.createUserAudiosForAuthUser(body);

      return res ?? [];
    });
  }
}
