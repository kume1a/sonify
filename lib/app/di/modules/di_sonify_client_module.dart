import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../configuration/app_environment.dart';
import '../injection_tokens.dart';

@module
abstract class DiSonifyClientModule {
  @lazySingleton
  @Named(InjectionToken.noInterceptorDio)
  Dio dio() {
    return NetworkClientFactory.createNoInterceptorDio(
      apiUrl: AppEnvironment.apiUrl,
      logPrint: Logger.root.info,
      // logPrint: null,
    );
  }

  @lazySingleton
  @Named(InjectionToken.authenticatedDio)
  Dio authenticatedDio(
    @Named(InjectionToken.noInterceptorDio) Dio noInterceptorDio,
    AuthTokenStore authTokenStore,
  ) {
    return NetworkClientFactory.createAuthenticatedDio(
      noInterceptorDio: noInterceptorDio,
      authTokenStore: authTokenStore,
      afterExit: () {},
      logPrint: Logger.root.info,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  @lazySingleton
  ApiClient apiClient(@Named(InjectionToken.authenticatedDio) Dio dio) {
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
  AuthTokenStore authTokenStore(FlutterSecureStorage secureStorage) {
    return SecureStoreageTokenStoreImpl(secureStorage);
  }

  @lazySingleton
  TokenPayloadMapper tokenPayloadMapper(UserMapper userMapper) {
    return TokenPayloadMapper(userMapper);
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

  // user ----------------------------------------------------------------
  @lazySingleton
  UserMapper userMapper() {
    return UserMapper();
  }

  @lazySingleton
  UserRemoteRepository userRemoteRepository(
    ApiClient apiClient,
    UserMapper userMapper,
  ) {
    return UserRemoteRepositoryImpl(apiClient, userMapper);
  }
}
