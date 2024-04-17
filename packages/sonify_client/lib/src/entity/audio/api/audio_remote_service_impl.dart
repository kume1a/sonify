import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../api/multipart_api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/download_youtube_audio_body.dart';
import '../model/download_youtube_audio_error.dart';
import '../model/get_audios_by_ids_body.dart';
import '../model/upload_user_local_music_error.dart';
import '../model/upload_user_local_music_params.dart';
import '../model/user_audio_dto.dart';
import 'audio_remote_service.dart';

class AudioRemoteServiceImpl with SafeHttpRequestWrap implements AudioRemoteService {
  AudioRemoteServiceImpl(
    this._apiClient,
    this._multipartApiClient,
  );

  final ApiClient _apiClient;
  final MultipartApiClient _multipartApiClient;

  @override
  Future<Either<DownloadYoutubeAudioError, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  }) {
    return callCatch(
      call: () async {
        final body = DownloadYoutubeAudioBody(videoId: videoId);

        return _apiClient.downloadYoutubeAudio(body);
      },
      networkError: const DownloadYoutubeAudioError.network(),
      unknownError: const DownloadYoutubeAudioError.unknown(),
      onResponseError: (response) {
        final res = ErrorResponseDto.fromJson(response!.data! as Map<String, dynamic>);

        return switch (res.message) {
          ApiExceptionMessageCode.audioAlreadyExists => const DownloadYoutubeAudioError.alreadyDownloaded(),
          _ => const DownloadYoutubeAudioError.unknown(),
        };
      },
    );
  }

  @override
  Future<Either<UploadUserLocalMusicError, UserAudioDto>> uploadUserLocalMusic(
    UploadUserLocalMusicParams params,
  ) {
    return callCatch(
      call: () => _multipartApiClient.importUserLocalMusic(params),
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

  @override
  Future<Either<NetworkCallError, List<String>>> getAuthUserAudioIds() {
    return callCatchHandleNetworkCallError(() => _apiClient.getAuthUserAudioIds());
  }

  @override
  Future<Either<NetworkCallError, List<UserAudioDto>>> getAuthUserAudiosByAudioIds(List<String> audioIds) {
    return callCatchHandleNetworkCallError(() {
      final body = GetAudiosByIdsBody(audioIds: audioIds);

      return _apiClient.getAuthUserUserAudios(body);
    });
  }
}
