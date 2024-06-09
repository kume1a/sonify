import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:logging/logging.dart';

import '../../audio/api/audio_local_repository.dart';
import '../../audio/model/audio.dart';
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
          .map((playlist) => playlist.copyWith(audios: remoteAudiosWithLocalPaths.dataOrThrow));
    }

    final localRes = await _playlistLocalRepository.getById(id);

    if (localRes.dataOrNull != null) {
      return localRes.map((data) => data!);
    }

    return Result.err();
  }

  Future<Result<List<Audio>>> _mergeRemotePlaylistWithLocalAudios(
    Playlist playlist,
  ) async {
    final remoteAudios = playlist.audios ?? [];

    final audioIds = remoteAudios.map((e) => e.id).whereNotNull().toList();

    final cachedAudios = await _audioLocalRepository.getByIds(audioIds);

    if (cachedAudios.isErr) {
      Logger.root.info('Failed to get audios from cache');
      return Result.err();
    }

    final remoteAudiosWithLocalPaths =
        remoteAudios.where((e) => e.localPath != null || e.localThumbnailPath != null).map((remoteAudio) {
      final cachedAudio =
          cachedAudios.dataOrThrow.firstWhereOrNull((cachedAudio) => cachedAudio.id == remoteAudio.id);

      if (cachedAudio != null) {
        return remoteAudio.copyWith(
          localPath: cachedAudio.localPath,
          localThumbnailPath: cachedAudio.localThumbnailPath,
        );
      }

      return remoteAudio;
    }).toList();

    return Result.success(remoteAudiosWithLocalPaths);
  }
}
