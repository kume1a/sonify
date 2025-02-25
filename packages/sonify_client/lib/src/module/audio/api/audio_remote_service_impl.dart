import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:common_utilities/common_utilities.dart';

import '../../../api/multipart_api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../../user_audio/model/user_audio_dto.dart';
import '../model/upload_user_local_music_error.dart';
import '../model/upload_user_local_music_params.dart';
import 'audio_remote_service.dart';

class AudioRemoteServiceImpl with SafeHttpRequestWrap implements AudioRemoteService {
  AudioRemoteServiceImpl(
    this._multipartApiClientProvider,
  );

  final Provider<MultipartApiClient> _multipartApiClientProvider;

  @override
  Future<Either<UploadUserLocalMusicError, UserAudioDto>> uploadUserLocalMusic(
    UploadUserLocalMusicParams params,
  ) {
    return callCatch(
      () => _multipartApiClientProvider.get().importUserLocalMusic(params),
      networkError: const UploadUserLocalMusicError.network(),
      unknownError: const UploadUserLocalMusicError.unknown(),
      onResponseError: (response) {
        final res = ErrorResponseDto.fromJson(response!.data! as Map<String, dynamic>);

        return switch (res.message) {
          ApiExceptionMessageCode.audioAlreadyExists => const UploadUserLocalMusicError.alreadyUploaded(),
          _ => const UploadUserLocalMusicError.unknown(),
        };
      },
    );
  }
}
