import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';

import '../../../api/api_client.dart';
import '../../../api/multipart_api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../model/audio_ids_body.dart';
import '../model/audio_like_dto.dart';
import '../model/download_youtube_audio_body.dart';
import '../model/download_youtube_audio_error.dart';
import '../model/get_audio_likes_body.dart';
import '../model/like_audio_body.dart';
import '../model/unlike_audio_body.dart';
import '../model/upload_user_local_music_error.dart';
import '../model/upload_user_local_music_params.dart';
import '../model/user_audio_dto.dart';
import 'audio_remote_service.dart';

class AudioRemoteServiceImpl with SafeHttpRequestWrap implements AudioRemoteService {
  AudioRemoteServiceImpl(
    this._apiClient,
    this._multipartApiClient,
    this._dio,
  );

  final ApiClient _apiClient;
  final MultipartApiClient _multipartApiClient;
  final Dio _dio;

  @override
  Future<Either<DownloadYoutubeAudioError, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  }) {
    const timeout = Duration(minutes: 1);

    return callCatch(
      call: () async {
        final result = await _dio.fetch<Map<String, dynamic>>(
          Options(
            method: 'POST',
            responseType: ResponseType.json,
            sendTimeout: timeout,
            receiveTimeout: timeout,
          ).compose(
            _dio.options,
            '/v1/audio/downloadYoutubeAudio',
            data: DownloadYoutubeAudioBody(videoId: videoId),
          ),
        );

        return UserAudioDto.fromJson(result.data!);
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
      final body = AudioIdsBody(audioIds: audioIds);

      return _apiClient.getAuthUserUserAudiosByIds(body);
    });
  }

  @override
  Future<Either<NetworkCallError, AudioLikeDto>> likeAudio({
    required String audioId,
  }) {
    return callCatchHandleNetworkCallError(() {
      final body = LikeAudioBody(audioId: audioId);

      return _apiClient.likeAudio(body);
    });
  }

  @override
  Future<Either<NetworkCallError, Unit>> unlikeAudio({required String audioId}) {
    return callCatchHandleNetworkCallError(() async {
      final body = UnlikeAudioBody(audioId: audioId);

      await _apiClient.unlikeAudio(body);

      return unit;
    });
  }

  @override
  Future<Either<NetworkCallError, List<AudioLikeDto>>> getAuthUserAudioLikes({
    List<String>? ids,
  }) async {
    return callCatchHandleNetworkCallError(() {
      final body = GetAudioLikesBody(ids: ids);

      return _apiClient.getAuthUserAudioLikes(body);
    });
  }
}
