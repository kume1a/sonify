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
      logPrint: Logger.root.finest,
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
      logPrint: Logger.root.finest,
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

  // usecase ----------------------------------------------------------------
  @lazySingleton
  ValidateAccessToken validateAccessToken(
    @Named(InjectionToken.noInterceptorDio) Dio dio,
  ) {
    return ValidateAccessTokenImpl(dio, AppEnvironment.apiUrl);
  }

  // ws ----------------------------------------------------------------
  @lazySingleton
  SocketProvider socketProvider(
    AuthTokenStore authTokenStore,
    ValidateAccessToken validateAccessToken,
  ) {
    return SocketProviderImpl(authTokenStore, validateAccessToken, AppEnvironment.wsUrl);
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
  SpotifyRemoteService spotifyAuthRemotService(ApiClient apiClient) {
    return SpotifyRemoteServiceImpl(apiClient);
  }

  // playlist ----------------------------------------------------------------
  @lazySingleton
  PlaylistRemoteService playlistRemoteService(ApiClient apiClient) {
    return PlaylistRemoteServiceImpl(apiClient);
  }

  // user playlist ----------------------------------------------------------------
  @lazySingleton
  UserPlaylistRemoteService userPlaylistRemoteService(ApiClient apiClient) {
    return UserPlaylistRemoteServiceImpl(apiClient);
  }

  // playlist audio ----------------------------------------------------------------
  @lazySingleton
  PlaylistAudioRemoteService playlistAudioRemoteService(ApiClient apiClient) {
    return PlaylistAudioRemoteServiceImpl(apiClient);
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

  // user audio ----------------------------------------------------------------
  @lazySingleton
  UserAudioRemoteService userAudioRemoteService(ApiClient apiClient) {
    return UserAudioRemoteServiceImpl(apiClient);
  }

  // hidden user audio ------------------------------------------------------------
  @lazySingleton
  HiddenUserAudioRemoteService hiddenUserAudioRemoteService(ApiClient apiClient) {
    return HiddenUserAudioRemoteServiceImpl(apiClient);
  }
}
