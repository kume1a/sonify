import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../configuration/app_environment.dart';

@module
abstract class DiSonifyClientModule {
  @lazySingleton
  Dio dio() {
    return NetworkClientFactory.createNoInterceptorDio(
      apiUrl: AppEnvironment.apiUrl,
      logPrint: Logger.root.info,
      // logPrint: null,
    );
  }

  @lazySingleton
  ApiClient apiClient(Dio dio) {
    return NetworkClientFactory.createApiClient(
      dio: dio,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  // youtube ----------------------------------------------------------------
  @lazySingleton
  YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper() {
    return YoutubeSearchSuggestionsMapper();
  }

  @lazySingleton
  YoutubeRepository youtubeMusicRepository(
    ApiClient apiClient,
    YoutubeExplode youtubeExplode,
    YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper,
  ) {
    return YoutubeRepositoryImpl(
      apiClient,
      youtubeExplode,
      youtubeSearchSuggestionsMapper,
    );
  }

  // auth ----------------------------------------------------------------
  @lazySingleton
  TokenPayloadMapper tokenPayloadMapper() {
    return TokenPayloadMapper();
  }

  @lazySingleton
  AuthRepository authRepository(
    ApiClient apiClient,
    TokenPayloadMapper tokenPayloadMapper,
  ) {
    return AuthRepositoryImpl(apiClient, tokenPayloadMapper);
  }

  // audio ----------------------------------------------------------------
  @lazySingleton
  AudioMapper audioMapper() {
    return AudioMapper();
  }

  @lazySingleton
  AudioRepository audioRepository(
    ApiClient apiClient,
    AudioMapper audioMapper,
  ) {
    return AudioRepositoryImpl(apiClient, audioMapper);
  }
}
