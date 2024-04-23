import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';
import 'package:uuid/uuid.dart';

@module
abstract class DiDomainModelModule {
  // shared ----------------------------------------------------------------
  @lazySingleton
  UuidFactory uuidFactory(Uuid uuid) {
    return UuidFactoryImpl(uuid);
  }

  // audio ----------------------------------------------------------------
  @lazySingleton
  AudioMapper audioMapper() {
    return AudioMapper();
  }

  @lazySingleton
  UserAudioMapper userAudioMapper(AudioMapper audioMapper) {
    return UserAudioMapper(audioMapper);
  }

  @lazySingleton
  AudioLikeMapper audioLikeMapper() {
    return AudioLikeMapper();
  }

  @lazySingleton
  AudioLocalRepository audioLocalRepository(
    UserAudioEntityDao userAudioEntityDao,
    AudioMapper audioMapper,
    UserAudioMapper userAudioMapper,
    AudioLikeEntityDao audioLikeEntityDao,
    AudioEntityDao audioEntityDao,
    AudioLikeMapper audioLikeMapper,
  ) {
    return AudioLocalRepositoryImpl(
      userAudioEntityDao,
      audioMapper,
      userAudioMapper,
      audioLikeEntityDao,
      audioEntityDao,
      audioLikeMapper,
    );
  }

  @lazySingleton
  AudioRemoteRepository audioRemoteRepository(
    AudioRemoteService audioRemoteService,
    UserAudioMapper userAudioMapper,
  ) {
    return AudioRemoteRepositoryImpl(
      audioRemoteService,
      userAudioMapper,
    );
  }

  // playlist ----------------------------------------------------------------
  @lazySingleton
  PlaylistMapper playlistMapper(AudioMapper audioMapper) {
    return PlaylistMapper(audioMapper);
  }

  @lazySingleton
  PlaylistRemoteRepository playlistRemoteRepository(
    PlaylistRemoteService playlistRemoteService,
    PlaylistMapper playlistMapper,
  ) {
    return PlaylistRemoteRepositoryImpl(playlistRemoteService, playlistMapper);
  }

  // server time ----------------------------------------------------------------
  @lazySingleton
  ServerTimeMapper serverTimeMapper() {
    return ServerTimeMapper();
  }

  @lazySingleton
  ServerTimeRemoteRepository serverTimeRemoteRepository(
    ServerTimeRemoteService serverTimeRemoteService,
    ServerTimeMapper serverTimeMapper,
  ) {
    return ServerTimeRemoteRepositoryImpl(serverTimeRemoteService, serverTimeMapper);
  }

  // auth ----------------------------------------------------------------
  @lazySingleton
  TokenPayloadMapper tokenPayloadMapper(UserMapper userMapper) {
    return TokenPayloadMapper(userMapper);
  }

  @lazySingleton
  AuthRemoteRepository authRemoteRepository(
    AuthRemoteService authRemoteService,
    TokenPayloadMapper tokenPayloadMapper,
  ) {
    return AuthRemoteRepositoryImpl(authRemoteService, tokenPayloadMapper);
  }

  @lazySingleton
  AuthUserInfoProvider authUserInfoProvider(
    AuthTokenStore authTokenStore,
    SharedPreferences sharedPreferences,
  ) {
    return AuthUserInfoProviderImpl(authTokenStore, sharedPreferences);
  }

  @lazySingleton
  AuthStatusProvider authStatusProvider(AuthTokenStore authTokenStore) {
    return AuthStatusProviderImpl(authTokenStore);
  }

  // user ----------------------------------------------------------------
  @lazySingleton
  UserMapper userMapper() {
    return UserMapper();
  }

  @lazySingleton
  UserRemoteRepository userRemoteRepository(
    UserRemoteService userRemoteService,
    UserMapper userMapper,
  ) {
    return UserRemoteRepositoryImpl(userRemoteService, userMapper);
  }

  // spotify ----------------------------------------------------------------
  @lazySingleton
  SpotifyTokenPayloadMapper spotifyTokenPayloadMapper() {
    return SpotifyTokenPayloadMapper();
  }

  SpotifyRefreshTokenPayloadMapper spotifyRefreshTokenPayloadMapper() {
    return SpotifyRefreshTokenPayloadMapper();
  }

  @lazySingleton
  SpotifyAuthRemoteRepository spotifyAuthRemoteRepository(
    SpotifyAuthRemoteService spotifyAuthRemoteService,
    SpotifyTokenPayloadMapper spotifyTokenPayloadMapper,
    SpotifyRefreshTokenPayloadMapper spotifyRefreshTokenPayloadMapper,
  ) {
    return SpotifyAuthRemoteRepositoryImpl(
      spotifyAuthRemoteService,
      spotifyTokenPayloadMapper,
      spotifyRefreshTokenPayloadMapper,
    );
  }

  // user sync datum ----------------------------------------------------------------
  @lazySingleton
  UserSyncDatumMapper userSyncDatumMapper() {
    return UserSyncDatumMapper();
  }

  @lazySingleton
  UserSyncDatumRemoteRepository userSyncDatumRemoteRepository(
    UserSyncDatumRemoteService userSyncDatumRemoteService,
    UserSyncDatumMapper userSyncDatumMapper,
  ) {
    return UserSyncDatumRemoteRepositoryImpl(userSyncDatumRemoteService, userSyncDatumMapper);
  }

  // youtube ----------------------------------------------------------------
  @lazySingleton
  YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper() {
    return YoutubeSearchSuggestionsMapper();
  }

  @lazySingleton
  YoutubeRemoteRepository youtubeRemoteRepository(
    YoutubeRemoteService youtubeRemoteService,
    YoutubeSearchSuggestionsMapper youtubeSearchSuggestionsMapper,
  ) {
    return YoutubeRemoteRepositoryImpl(
      youtubeRemoteService,
      youtubeSearchSuggestionsMapper,
    );
  }

  // download_file ----------------------------------------------------------------
  @lazySingleton
  DownloadTaskMapper downloadTaskMapper(UuidFactory uuidFactory) {
    return DownloadTaskMapper(uuidFactory);
  }

  @lazySingleton
  DownloadedTaskMapper downloadedTaskMapper(UserAudioMapper userAudioMapper) {
    return DownloadedTaskMapper(userAudioMapper);
  }

  @lazySingleton
  DownloadedTaskLocalRepository downloadedTaskLocalRepository(
    DownloadedTaskEntityDao downloadedTaskEntityDao,
    DownloadedTaskMapper downloadedTaskMapper,
    UserAudioMapper userAudioMapper,
    AuthUserInfoProvider authUserInfoProvider,
  ) {
    return DownloadedTaskLocalRepositoryImpl(
      downloadedTaskEntityDao,
      downloadedTaskMapper,
      userAudioMapper,
      authUserInfoProvider,
    );
  }
}
