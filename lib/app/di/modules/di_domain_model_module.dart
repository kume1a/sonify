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
  AudioLikeMapper audioLikeMapper() {
    return AudioLikeMapper();
  }

  @lazySingleton
  AudioMapper audioMapper(AudioLikeMapper audioLikeMapper) {
    return AudioMapper(audioLikeMapper);
  }

  @lazySingleton
  UserAudioMapper userAudioMapper(AudioMapper audioMapper) {
    return UserAudioMapper(audioMapper);
  }

  @lazySingleton
  AudioLocalRepository audioLocalRepository(
    UserAudioEntityDao userAudioEntityDao,
    AudioMapper audioMapper,
    UserAudioMapper userAudioMapper,
    AudioEntityDao audioEntityDao,
  ) {
    return AudioLocalRepositoryImpl(
      userAudioEntityDao,
      audioMapper,
      userAudioMapper,
      audioEntityDao,
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

  // audio like ----------------------------------------------------------------
  @lazySingleton
  AudioLikeLocalRepository audioLikeLocalRepository(
    AudioLikeEntityDao audioLikeEntityDao,
    AudioLikeMapper audioLikeMapper,
    DbBatchProviderFactory dbBatchProviderFactory,
  ) {
    return AudioLikeLocalRepositoryImpl(
      audioLikeEntityDao,
      audioLikeMapper,
      dbBatchProviderFactory,
    );
  }

  AudioLikeRemoteRepository audioLikeRemoteRepository(
    AudioLikeRemoteService audioLikeRemoteService,
    AudioLikeMapper audioLikeMapper,
  ) {
    return AudioLikeRemoteRepositoryImpl(
      audioLikeRemoteService,
      audioLikeMapper,
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

  @lazySingleton
  PlaylistLocalRepository playlistLocalRepository(
    PlaylistEntityDao playlistEntityDao,
    DbBatchProviderFactory dbBatchProviderFactory,
    PlaylistMapper playlistMapper,
  ) {
    return PlaylistLocalRepositoryImpl(
      playlistEntityDao,
      dbBatchProviderFactory,
      playlistMapper,
    );
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
    return ServerTimeRemoteRepositoryImpl(
      serverTimeRemoteService,
      serverTimeMapper,
    );
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
    AuthUserInfoProvider authUserInfoProvider,
  ) {
    return DownloadedTaskLocalRepositoryImpl(
      downloadedTaskEntityDao,
      downloadedTaskMapper,
      authUserInfoProvider,
    );
  }

  // pending change ------------------------------------------------------------
  @lazySingleton
  PendingChangeMapper pendingChangeMapper() {
    return PendingChangeMapper();
  }

  @lazySingleton
  PendingChangeLocalRepository pendingChangeLocalRepository(
    PendingChangeEntityDao pendingChangeEntityDao,
    PendingChangeMapper pendingChangeMapper,
  ) {
    return PendingChangeLocalRepositoryImpl(
      pendingChangeEntityDao,
      pendingChangeMapper,
    );
  }
}
