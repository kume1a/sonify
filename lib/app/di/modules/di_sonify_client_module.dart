import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../features/auth/api/after_sign_out.dart';
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
    AfterSignOut afterSignOut,
  ) {
    return NetworkClientFactory.createAuthenticatedDio(
      noInterceptorDio: noInterceptorDio,
      authTokenStore: authTokenStore,
      afterExit: afterSignOut.call,
      logPrint: Logger.root.info,
      // logPrint: null,
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
  AuthRemoteService authRemoteService(ApiClient apiClient) {
    return AuthRemoteServiceImpl(apiClient);
  }

  // audio ----------------------------------------------------------------
  @lazySingleton
  AudioRemoteService audioRepository(ApiClient apiClient) {
    return AudioRemoteServiceImpl(apiClient);
  }

  // user ----------------------------------------------------------------
  @lazySingleton
  UserRemoteService userRemoteService(ApiClient apiClient) {
    return UserRemoteServiceImpl(apiClient);
  }

  // spotify ----------------------------------------------------------------
  @lazySingleton
  SpotifyAuthRemoteService spotifyAuthRemotService(ApiClient apiClient) {
    return SpotifyAuthRemoteServiceImpl(apiClient);
  }

  // playlist ----------------------------------------------------------------
  @lazySingleton
  PlaylistRemoteService playlistRemoteService(ApiClient apiClient) {
    return PlaylistRemoteServiceImpl(apiClient);
  }

  // user sync datum ----------------------------------------------------------------
  @lazySingleton
  UserSyncDatumRemoteService userSyncDatumRemoteService(ApiClient apiClient) {
    return UserSyncDatumRemoteServiceImpl(apiClient);
  }

  // server time ----------------------------------------------------------------
  @lazySingleton
  ServerTimeRemoteService serverTimeRemoteService(ApiClient apiClient) {
    return ServerTimeRemoteServiceImpl(apiClient);
  }
}
