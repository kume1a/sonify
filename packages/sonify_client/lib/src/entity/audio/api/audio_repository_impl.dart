import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/download_youtube_audio_body.dart';
import '../model/download_youtube_audio_failure.dart';
import '../model/user_audio.dart';
import '../util/user_audio_mapper.dart';
import 'audio_repository.dart';

class AudioRepositoryImpl with SafeHttpRequestWrap implements AudioRepository {
  AudioRepositoryImpl(
    this._apiClient,
    this._userAudioMapper,
  );

  final ApiClient _apiClient;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Either<DownloadYoutubeAudioFailure, UserAudio>> downloadYoutubeAudio(String videoId) {
    return callCatch(
      call: () async {
        final body = DownloadYoutubeAudioBody(videoId: videoId);

        final res = await _apiClient.downloadYoutubeAudio(body);

        return _userAudioMapper.dtoToModel(res);
      },
      networkError: DownloadYoutubeAudioFailure.network(),
      unknownError: DownloadYoutubeAudioFailure.unknown(),
      onResponseError: (response) {
        final res = ErrorResponseDto.fromJson(response!.data! as Map<String, dynamic>);

        return switch (res.message) {
          ApiExceptionMessageCode.audioAlreadyExists => DownloadYoutubeAudioFailure.alreadyDownloaded(),
          _ => DownloadYoutubeAudioFailure.unknown(),
        };
      },
    );
  }
}
