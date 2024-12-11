import 'package:common_utilities/common_utilities.dart';
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
  AudioMapper audioMapper(
    AudioLikeMapper audioLikeMapper,
    HiddenUserAudioMapper hiddenUserAudioMapper,
  ) {
    return AudioMapper(
      audioLikeMapper,
      hiddenUserAudioMapper,
    );
  }

  @lazySingleton
  DeleteUnusedLocalAudio deleteUnusedLocalAudio(
    AudioLocalRepository audioLocalRepository,
    UserAudioEntityDao userAudioEntityDao,
    PlaylistAudioEntityDao playlistAudioEntityDao,
  ) {
    return DeleteUnusedLocalAudioImpl(
      audioLocalRepository,
      userAudioEntityDao,
      playlistAudioEntityDao,
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

  @lazySingleton
  AudioLocalRepository audioLocalRepository(
    AudioMapper audioMapper,
    AudioEntityDao audioEntityDao,
  ) {
    return AudioLocalRepositoryImpl(
      audioMapper,
      audioEntityDao,
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
  ProcessStatusMapper processStatusMapper() {
    return ProcessStatusMapper();
  }

  @lazySingleton
  PlaylistMapper playlistMapper(
    PlaylistAudioMapper playlistAudioMapper,
    ProcessStatusMapper processStatusMapper,
  ) {
    return PlaylistMapper(playlistAudioMapper, processStatusMapper);
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
    PlaylistAudioEntityDao playlistAudioEntityDao,
  ) {
    return PlaylistLocalRepositoryImpl(
      playlistEntityDao,
      dbBatchProviderFactory,
      playlistMapper,
      playlistAudioEntityDao,
    );
  }

  @injectable
  PlaylistUpdatedEventChannel playlistUpdatedEventChannel(
    PlaylistMapper playlistMapper,
    DisposableProvider<SocketHolder> socketHolderProvider,
  ) {
    return WsPlaylistUpdatedEventChannel(
      playlistMapper,
      socketHolderProvider,
    );
  }

  // playlist audio ----------------------------------------------------------------
  @lazySingleton
  PlaylistAudioMapper playlistAudioMapper(AudioMapper audioMapper) {
    return PlaylistAudioMapper(audioMapper);
  }

  @lazySingleton
  PlaylistAudioRemoteRepository playlistAudioRemoteRepository(
    PlaylistAudioRemoteService playlistAudioRemoteService,
    PlaylistAudioMapper playlistAudioMapper,
  ) {
    return PlaylistAudioRemoteRepositoryImpl(
      playlistAudioRemoteService,
      playlistAudioMapper,
    );
  }

  @lazySingleton
  PlaylistAudioLocalRepository playlistAudioLocalRepository(
    PlaylistAudioEntityDao playlistAudioEntityDao,
    PlaylistAudioMapper playlistAudioMapper,
    DbBatchProviderFactory dbBatchProviderFactory,
    DeleteUnusedLocalAudio deleteUnusedLocalAudio,
  ) {
    return PlaylistAudioLocalRepositoryImpl(
      playlistAudioEntityDao,
      playlistAudioMapper,
      dbBatchProviderFactory,
      deleteUnusedLocalAudio,
    );
  }

  // user playlist ----------------------------------------------------------------
  @lazySingleton
  UserPlaylistMapper userPlaylistMapper(PlaylistMapper playlistMapper) {
    return UserPlaylistMapper(playlistMapper);
  }

  @lazySingleton
  UserPlaylistLocalRepository userPlaylistLocalRepository(
    UserPlaylistEntityDao userPlaylistEntityDao,
    UserPlaylistMapper userPlaylistMapper,
    DbBatchProviderFactory dbBatchProviderFactory,
    PlaylistLocalRepository playlistLocalRepository,
  ) {
    return UserPlaylistLocalRepositoryImpl(
      userPlaylistEntityDao,
      userPlaylistMapper,
      dbBatchProviderFactory,
      playlistLocalRepository,
    );
  }

  @lazySingleton
  UserPlaylistRemoteRepository userPlaylistRemoteRepository(
    UserPlaylistRemoteService userPlaylistRemoteService,
    UserPlaylistMapper userPlaylistMapper,
  ) {
    return UserPlaylistRemoteRepositoryImpl(
      userPlaylistRemoteService,
      userPlaylistMapper,
    );
  }

  // user audio ----------------------------------------------------------------
  @lazySingleton
  UserAudioMapper userAudioMapper(AudioMapper audioMapper) {
    return UserAudioMapper(audioMapper);
  }

  @lazySingleton
  UserAudioLocalRepository userAudioLocalRepository(
    UserAudioEntityDao userAudioEntityDao,
    UserAudioMapper userAudioMapper,
    DeleteUnusedLocalAudio deleteUnusedLocalAudio,
  ) {
    return UserAudioLocalRepositoryImpl(
      userAudioEntityDao,
      userAudioMapper,
      deleteUnusedLocalAudio,
    );
  }

  @lazySingleton
  UserAudioRemoteRepository userAudioRemoteRepository(
    UserAudioRemoteService userAudioRemoteService,
    UserAudioMapper userAudioMapper,
  ) {
    return UserAudioRemoteRepositoryImpl(
      userAudioRemoteService,
      userAudioMapper,
    );
  }

  // hidden user audio
  @lazySingleton
  HiddenUserAudioMapper hiddenUserAudioMapper() {
    return HiddenUserAudioMapper();
  }

  @lazySingleton
  HiddenUserAudioRemoteRepository hiddenUserAudioRemoteRepository(
    HiddenUserAudioRemoteService hiddenUserAudioRemoteService,
    HiddenUserAudioMapper hiddenUserAudioMapper,
  ) {
    return HiddenUserAudioRemoteRepositoryImpl(
      hiddenUserAudioRemoteService,
      hiddenUserAudioMapper,
    );
  }

  @lazySingleton
  HiddenUserAudioLocalRepository hiddenUserAudioLocalRepository(
    HiddenUserAudioEntityDao hiddenUserAudioEntityDao,
    HiddenUserAudioMapper hiddenUserAudioMapper,
    DbBatchProviderFactory dbBatchProviderFactory,
  ) {
    return HiddenUserAudioLocalRepositoryImpl(
      hiddenUserAudioEntityDao,
      hiddenUserAudioMapper,
      dbBatchProviderFactory,
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

  @lazySingleton
  SpotifyRefreshTokenPayloadMapper spotifyRefreshTokenPayloadMapper() {
    return SpotifyRefreshTokenPayloadMapper();
  }

  @lazySingleton
  SpotifySearchResultMapper spotifySearchResultMapper() {
    return SpotifySearchResultMapper();
  }

  @lazySingleton
  SpotifyRemoteRepository spotifyAuthRemoteRepository(
    SpotifyRemoteService spotifyAuthRemoteService,
    SpotifyTokenPayloadMapper spotifyTokenPayloadMapper,
    SpotifyRefreshTokenPayloadMapper spotifyRefreshTokenPayloadMapper,
    SpotifySearchResultMapper spotifySearchResultMapper,
    PlaylistMapper playlistMapper,
  ) {
    return SpotifyRemoteRepositoryImpl(
      spotifyAuthRemoteService,
      spotifyTokenPayloadMapper,
      spotifyRefreshTokenPayloadMapper,
      spotifySearchResultMapper,
      playlistMapper,
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

  @lazySingleton
  UserSyncDatumLocalRepository userSyncDatumLocalRepository(
    SharedPreferences sharedPreferences,
  ) {
    return UserSyncDatumLocalRepositoryImpl(sharedPreferences);
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
    UserAudioMapper userAudioMapper,
  ) {
    return YoutubeRemoteRepositoryImpl(
      youtubeRemoteService,
      youtubeSearchSuggestionsMapper,
      userAudioMapper,
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

  // usecase ------------------------------------------------------------
  @lazySingleton
  GetAuthUserLocalPlaylistIds getAuthUserLocalPlaylistIds(
    AuthUserInfoProvider authUserInfoProvider,
    UserPlaylistLocalRepository userPlaylistLocalRepository,
  ) {
    return GetAuthUserLocalPlaylistIds(
      authUserInfoProvider,
      userPlaylistLocalRepository,
    );
  }

  @lazySingleton
  SaveUserAudioWithAudio saveUserAudioWithAudio(
    UserAudioLocalRepository userAudioLocalRepository,
    AudioLocalRepository audioLocalRepository,
  ) {
    return SaveUserAudioWithAudio(
      userAudioLocalRepository,
      audioLocalRepository,
    );
  }

  @lazySingleton
  SavePlaylistAudioWithAudio savePlaylistAudioWithAudio(
    PlaylistAudioLocalRepository playlistAudioLocalRepository,
    AudioLocalRepository audioLocalRepository,
  ) {
    return SavePlaylistAudioWithAudio(
      playlistAudioLocalRepository,
      audioLocalRepository,
    );
  }
}
