import 'package:common_models/common_models.dart';

import '../../../../domain_data.dart';
import 'playlist_cached_repository.dart';

class PlaylistCachedRepositoryImpl implements PlaylistCachedRepository {
  PlaylistCachedRepositoryImpl(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;

  @override
  Future<Result<Playlist>> getById(String id) async {
    final remoteResult = await _playlistRemoteRepository.getById(id);

    if (remoteResult.isRight) {
      return remoteResult.toResult();
    }

    final localRes = await _playlistLocalRepository.getById(id);

    if (localRes.dataOrNull != null) {
      return localRes.map((data) => data!);
    }

    return Result.err();
  }
}
