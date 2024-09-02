import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/audio_id_body.dart';
import '../../../shared/dto/audio_ids_body.dart';
import '../model/user_audio_dto.dart';
import 'user_audio_remote_service.dart';

class UserAudioRemoteServiceImpl with SafeHttpRequestWrap implements UserAudioRemoteService {
  UserAudioRemoteServiceImpl(
    this._apiClientProvider,
  );

  final Provider<ApiClient> _apiClientProvider;

  @override
  Future<Either<NetworkCallError, List<UserAudioDto>>> createForAuthUser({
    required List<String> audioIds,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdsBody(audioIds: audioIds);

      final res = await _apiClientProvider.get().createUserAudiosForAuthUser(body);

      return res ?? [];
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> deleteForAuthUser({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() async {
      final body = AudioIdBody(audioId: audioId);

      await _apiClientProvider.get().deleteUserAudioForAuthUser(body);

      return unit;
    });
  }
}
