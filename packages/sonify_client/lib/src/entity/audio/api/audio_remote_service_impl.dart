import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/download_youtube_audio_body.dart';
import '../model/download_youtube_audio_failure.dart';
import '../model/user_audio_dto.dart';
import 'audio_remote_service.dart';

class AudioRemoteServiceImpl with SafeHttpRequestWrap implements AudioRemoteService {
  AudioRemoteServiceImpl(
    this._apiClient,
  );

  final ApiClient _apiClient;

  @override
  Future<Either<DownloadYoutubeAudioFailure, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  }) {
    return callCatch(
      call: () async {
        final body = DownloadYoutubeAudioBody(videoId: videoId);

        return _apiClient.downloadYoutubeAudio(body);
      },
      networkError: const DownloadYoutubeAudioFailure.network(),
      unknownError: const DownloadYoutubeAudioFailure.unknown(),
      onResponseError: (response) {
        final res = ErrorResponseDto.fromJson(response!.data! as Map<String, dynamic>);

        return switch (res.message) {
          ApiExceptionMessageCode.audioAlreadyExists => const DownloadYoutubeAudioFailure.alreadyDownloaded(),
          _ => const DownloadYoutubeAudioFailure.unknown(),
        };
      },
    );
  }
}
