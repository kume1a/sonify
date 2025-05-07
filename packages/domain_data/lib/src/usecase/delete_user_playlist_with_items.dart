import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../entities/index.dart';

class DeleteUserPlaylistWithItems {
  DeleteUserPlaylistWithItems(
    this._userPlaylistRemoteRepository,
    this._playlistLocalRepository,
    this._userPlaylistLocalRepository,
    this._playlistAudioLocalRepository,
    this._dbBatchProviderFactory,
  );

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final PlaylistAudioLocalRepository _playlistAudioLocalRepository;
  final DbBatchProviderFactory _dbBatchProviderFactory;

  Future<Result<UserPlaylist>> call({
    required String userPlaylistId,
  }) async {
    final userPlaylist = await _userPlaylistLocalRepository.getById(userPlaylistId);
    if (userPlaylist.isErr) {
      return Result.err();
    }

    final userPlaylistResult = userPlaylist.dataOrThrow;
    if (userPlaylistResult == null) {
      return Result.err();
    }

    final deleteRemoteUserPlaylistRes = await _userPlaylistRemoteRepository.deleteById(userPlaylistId);
    if (deleteRemoteUserPlaylistRes.isLeft) {
      return Result.err();
    }

    final batchProvider = _dbBatchProviderFactory.newBatchProvider();

    final results = await Future.wait([
      _userPlaylistLocalRepository.deleteById(
        userPlaylistId,
        batchProvider: batchProvider,
      ),
      _playlistAudioLocalRepository.deleteByPlaylistId(
        userPlaylistResult.playlistId,
        batchProvider: batchProvider,
      ),
      _playlistLocalRepository.deleteById(
        userPlaylistResult.playlistId,
        batchProvider: batchProvider,
      ),
    ]);

    if (results.any((result) => result.isErr)) {
      return Result.err();
    }

    await batchProvider.commit();

    return Result.success(userPlaylistResult);
  }
}
