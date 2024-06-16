import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../api/api_client.dart';
import '../../../shared/api_exception_message_code.dart';
import '../../../shared/dto/error_response_dto.dart';
import '../../../shared/dto/url_dto.dart';
import '../../user_audio/model/user_audio_dto.dart';
import '../model/download_youtube_audio_body.dart';
import '../model/download_youtube_audio_error.dart';
import '../model/youtube_search_suggestions_dto.dart';
import 'youtube_remote_service.dart';

class YoutubeRemoteServiceImpl with SafeHttpRequestWrap, ResultWrap implements YoutubeRemoteService {
  YoutubeRemoteServiceImpl(
    this._apiClient,
    this._yt,
    this._dio,
  );

  final ApiClient _apiClient;
  final YoutubeExplode _yt;
  final Dio _dio;

  @override
  Future<Either<DownloadYoutubeAudioError, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  }) {
    const timeout = Duration(minutes: 1);

    return callCatch(
      () async {
        final result = await _dio.fetch<Map<String, dynamic>>(
          Options(
            method: 'POST',
            responseType: ResponseType.json,
            sendTimeout: timeout,
            receiveTimeout: timeout,
          ).compose(
            _dio.options,
            '/v1/youtube/downloadAudio',
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
  Future<Either<NetworkCallError, UrlDto>> getYoutubeMusicUrl(String videoId) {
    return callCatchHandleNetworkCallError(
      () => _apiClient.getYoutubeMusicUrl(videoId),
    );
  }

  @override
  Future<Either<NetworkCallError, YoutubeSearchSuggestionsDto>> getYoutubeSuggestions(String keyword) async {
    return callCatchHandleNetworkCallError(
      () => _apiClient.getYoutubeSuggestions(keyword),
    );
  }

  @override
  Future<Result<List<Video>>> search(String query) async {
    return wrapWithResult(() => _yt.search.search(query));
  }

  @override
  Future<Result<Video>> getVideo(String videoId) async {
    return wrapWithResult(() => _yt.videos.get(videoId));
  }

  @override
  Future<Result<UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams(
    String videoId,
  ) async {
    return wrapWithResult(() async {
      final manifest = await _yt.videos.streams.getManifest(videoId);

      return manifest.audioOnly;
    });
  }

  @override
  Future<Result<MuxedStreamInfo>> getHighestQualityMuxedStreamInfo(
    String videoId,
  ) async {
    return wrapWithResult(() async {
      final manifest = await _yt.videos.streams.getManifest(videoId);

      return manifest.muxed.withHighestBitrate();
    });
  }
}
