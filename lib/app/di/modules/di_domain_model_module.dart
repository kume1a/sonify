import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

@module
abstract class DiDomainModelModule {
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
  AudioLocalRepository audioLocalRepository(
    AudioEntityDao audioEntityDao,
    AudioMapper audioMapper,
  ) {
    return AudioLocalRepositoryImpl(audioEntityDao, audioMapper);
  }

  @lazySingleton
  AudioRemoteRepository audioRemoteRepository(
    AudioRemoteService audioRemoteService,
    UserAudioMapper userAudioMapper,
  ) {
    return AudioRemoteRepositoryImpl(audioRemoteService, userAudioMapper);
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
}
