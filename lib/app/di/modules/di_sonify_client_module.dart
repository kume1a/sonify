import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../configuration/app_environment.dart';

@module
abstract class DiSonifyClientModule {
  @lazySingleton
  Dio dio() {
    return NetworkClientFactory.createNoInterceptorDio(
      apiUrl: AppEnvironment.apiUrl,
      // logPrint: Logger.root.info,
      logPrint: null,
    );
  }

  @lazySingleton
  ApiClient apiClient(Dio dio) {
    return NetworkClientFactory.createApiClient(
      dio: dio,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  @lazySingleton
  YoutubeMusicHomeDtoParser youtubeMusicHomeDtoParser() {
    return YoutubeMusicHomeDtoParser();
  }

  @lazySingleton
  YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper() {
    return YoutubeSearchSuggestionsMapper();
  }

  @lazySingleton
  YoutubeRepository youtubeMusicRepository(
    ApiClient apiClient,
    Dio dio,
    YoutubeExplode youtubeExplode,
    YoutubeMusicHomeDtoParser youtubeMusicHomeDtoParser,
    YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper,
  ) {
    return YoutubeRepositoryImpl(
      apiClient,
      dio,
      youtubeExplode,
      youtubeMusicHomeDtoParser,
      youtubeSearchSuggestionsMapper,
    );
  }
}
