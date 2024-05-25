import 'package:dio/dio.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../features/auth/api/after_sign_out.dart';
import '../injection_tokens.dart';

@module
abstract class DiSonifyClientModule {
  @lazySingleton
  @Named(InjectionToken.noInterceptorDio)
  Dio dio() {
    return NetworkClientFactory.createNoInterceptorDio(
      apiUrl: AppEnvironment.apiUrl,
      logPrint: Logger.root.finer,
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
      logPrint: Logger.root.finer,
      // logPrint: null,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  @lazySingleton
  ApiClient apiClient(
    @Named(InjectionToken.authenticatedDio) Dio dio,
  ) {
    return NetworkClientFactory.createApiClient(
      dio: dio,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  @lazySingleton
  MultipartApiClient multipartApiClient(
    @Named(InjectionToken.authenticatedDio) Dio dio,
  ) {
    return NetworkClientFactory.createMultipartApiClient(
      dio: dio,
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  // youtube ----------------------------------------------------------------
  @lazySingleton
  YoutubeRemoteService youtubeRemoteService(
    ApiClient apiClient,
    YoutubeExplode youtubeExplode,
    @Named(InjectionToken.authenticatedDio) Dio dio,
  ) {
    return YoutubeRemoteServiceImpl(
      apiClient,
      youtubeExplode,
      dio,
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
  AudioRemoteService audioRepository(
    ApiClient apiClient,
    MultipartApiClient multipartApiClient,
  ) {
    return AudioRemoteServiceImpl(apiClient, multipartApiClient);
  }

  // audio like ----------------------------------------------------------------
  @lazySingleton
  AudioLikeRemoteService audioLikeRemoteService(ApiClient apiClient) {
    return AudioLikeRemoteServiceImpl(apiClient);
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
  PlaylistRemoteService playlistRemoteService(
    ApiClient apiClient,
    @Named(InjectionToken.authenticatedDio) Dio dio,
  ) {
    return PlaylistRemoteServiceImpl(apiClient, dio);
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
