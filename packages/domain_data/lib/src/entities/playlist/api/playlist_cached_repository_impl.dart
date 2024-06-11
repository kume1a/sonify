import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../../audio/api/audio_local_repository.dart';
import '../../playlist_audio/model/playlist_audio.dart';
import '../model/playlist.dart';
import 'playlist_cached_repository.dart';
import 'playlist_local_repository.dart';
import 'playlist_remote_repository.dart';

class PlaylistCachedRepositoryImpl implements PlaylistCachedRepository {
  PlaylistCachedRepositoryImpl(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
    this._audioLocalRepository,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;
  final AudioLocalRepository _audioLocalRepository;

  @override
  Future<Result<Playlist>> getById(String id) async {
    final remoteResult = await _playlistRemoteRepository.getById(id);

    if (remoteResult.isRight) {
      final remoteAudiosWithLocalPaths = await _mergeRemotePlaylistWithLocalAudios(remoteResult.rightOrThrow);

      if (remoteAudiosWithLocalPaths.isErr) {
        return remoteResult.toResult();
      }

      return remoteResult
          .toResult()
          .map((playlist) => playlist.copyWith(playlistAudios: remoteAudiosWithLocalPaths.dataOrThrow));
    }

    final localRes = await _playlistLocalRepository.getById(id);

    if (localRes.dataOrNull != null) {
      return localRes.map((data) => data!);
    }

    return Result.err();
  }

  Future<Result<List<PlaylistAudio>>> _mergeRemotePlaylistWithLocalAudios(
    Playlist playlist,
  ) async {
    final remotePlaylistAudios = playlist.playlistAudios ?? [];

    final audioIds = remotePlaylistAudios.map((e) => e.audioId).whereNotNull().toList();

    final cachedAudios = await _audioLocalRepository.getByIds(audioIds);

    if (cachedAudios.isErr) {
      Logger.root.info('Failed to get audios from cache');
      return Result.err();
    }

    final remoteAudiosWithLocalPaths = remotePlaylistAudios.map((remotePlaylistAudio) {
      final cachedAudio = cachedAudios.dataOrThrow
          .firstWhereOrNull((cachedAudio) => cachedAudio.id == remotePlaylistAudio.audioId);

      if (cachedAudio == null) {
        return remotePlaylistAudio;
      }

      return remotePlaylistAudio.copyWith(
        audio: remotePlaylistAudio.audio?.copyWith(
          localPath: cachedAudio.localPath,
          localThumbnailPath: cachedAudio.localThumbnailPath,
        ),
      );
    }).toList();

    return Result.success(remoteAudiosWithLocalPaths);
  }
}
