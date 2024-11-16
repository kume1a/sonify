import 'package:common_utilities/common_utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../features/auth/api/after_sign_out.dart';
import '../../../features/dynamic_client/api/dynamic_api_url_provider.dart';
import '../injection_tokens.dart';

@module
abstract class DiSonifyClientModule {
  @lazySingleton
  @Named(InjectionToken.noInterceptorDio)
  Dio dio() {
    return NetworkClientFactory.createNoInterceptorDio(
      // logPrint: Logger.root.finest,
      logPrint: null,
    );
  }

  @lazySingleton
  @Named(InjectionToken.authenticatedDio)
  Dio authenticatedDio(
    AuthTokenStore authTokenStore,
    AfterSignOut afterSignOut,
  ) {
    return NetworkClientFactory.createAuthenticatedDio(
      authTokenStore: authTokenStore,
      afterExit: afterSignOut.call,
      // logPrint: Logger.root.finest,
      logPrint: null,
    );
  }

  // usecase ----------------------------------------------------------------
  @lazySingleton
  ValidateAccessToken validateAccessToken(
    @Named(InjectionToken.noInterceptorDio) Dio dio,
    DynamicApiUrlProvider dynamicApiUrlProvider,
  ) {
    return ValidateAccessTokenImpl(dio, dynamicApiUrlProvider);
  }

  // youtube ----------------------------------------------------------------
  @lazySingleton
  YoutubeRemoteService youtubeRemoteService(
    Provider<ApiClient> apiClientProvider,
    DynamicApiUrlProvider apiUrlProvider,
    YoutubeExplode youtubeExplode,
    @Named(InjectionToken.authenticatedDio) Dio dio,
  ) {
    return YoutubeRemoteServiceImpl(
      apiClientProvider,
      apiUrlProvider,
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
  AuthRemoteService authRemoteService(Provider<ApiClient> apiClientProvider) {
    return AuthRemoteServiceImpl(apiClientProvider);
  }

  // audio ----------------------------------------------------------------
  @lazySingleton
  AudioRemoteService audioRepository(
    Provider<ApiClient> apiClientProvider,
    Provider<MultipartApiClient> multipartApiClientProvider,
  ) {
    return AudioRemoteServiceImpl(apiClientProvider, multipartApiClientProvider);
  }

  // audio like ----------------------------------------------------------------
  @lazySingleton
  AudioLikeRemoteService audioLikeRemoteService(Provider<ApiClient> apiClientProvider) {
    return AudioLikeRemoteServiceImpl(apiClientProvider);
  }

  // user ----------------------------------------------------------------
  @lazySingleton
  UserRemoteService userRemoteService(Provider<ApiClient> apiClientProvider) {
    return UserRemoteServiceImpl(apiClientProvider);
  }

  // spotify ----------------------------------------------------------------
  @lazySingleton
  SpotifyRemoteService spotifyAuthRemotService(Provider<ApiClient> apiClientProvider) {
    return SpotifyRemoteServiceImpl(apiClientProvider);
  }

  // playlist ----------------------------------------------------------------
  @lazySingleton
  PlaylistRemoteService playlistRemoteService(Provider<ApiClient> apiClientProvider) {
    return PlaylistRemoteServiceImpl(apiClientProvider);
  }

  // user playlist ----------------------------------------------------------------
  @lazySingleton
  UserPlaylistRemoteService userPlaylistRemoteService(Provider<ApiClient> apiClientProvider) {
    return UserPlaylistRemoteServiceImpl(apiClientProvider);
  }

  // playlist audio ----------------------------------------------------------------
  @lazySingleton
  PlaylistAudioRemoteService playlistAudioRemoteService(Provider<ApiClient> apiClientProvider) {
    return PlaylistAudioRemoteServiceImpl(apiClientProvider);
  }

  // user sync datum ----------------------------------------------------------------
  @lazySingleton
  UserSyncDatumRemoteService userSyncDatumRemoteService(Provider<ApiClient> apiClientProvider) {
    return UserSyncDatumRemoteServiceImpl(apiClientProvider);
  }

  // server time ----------------------------------------------------------------
  @lazySingleton
  ServerTimeRemoteService serverTimeRemoteService(Provider<ApiClient> apiClientProvider) {
    return ServerTimeRemoteServiceImpl(apiClientProvider);
  }

  // user audio ----------------------------------------------------------------
  @lazySingleton
  UserAudioRemoteService userAudioRemoteService(Provider<ApiClient> apiClientProvider) {
    return UserAudioRemoteServiceImpl(apiClientProvider);
  }

  // hidden user audio ------------------------------------------------------------
  @lazySingleton
  HiddenUserAudioRemoteService hiddenUserAudioRemoteService(Provider<ApiClient> apiClientProvider) {
    return HiddenUserAudioRemoteServiceImpl(apiClientProvider);
  }
}
