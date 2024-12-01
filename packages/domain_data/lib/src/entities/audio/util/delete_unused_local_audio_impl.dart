import 'dart:io';

import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/stringx.dart';
import '../api/audio_local_repository.dart';
import 'delete_unused_local_audio.dart';

class DeleteUnusedLocalAudioImpl with ResultWrap implements DeleteUnusedLocalAudio {
  DeleteUnusedLocalAudioImpl(
    this._audioLocalRepository,
    this._userAudioEntityDao,
    this._playlistAudioEntityDao,
  );

  final AudioLocalRepository _audioLocalRepository;
  final UserAudioEntityDao _userAudioEntityDao;
  final PlaylistAudioEntityDao _playlistAudioEntityDao;

  @override
  Future<EmptyResult> deleteById(String id) async {
    final audioRes = await _audioLocalRepository.getById(id);

    if (audioRes.isErr) {
      return EmptyResult.err();
    }

    final audio = audioRes.dataOrThrow;
    if (audio == null) {
      return EmptyResult.err();
    }

    final userAudioRelCount = await wrapWithResult(() => _userAudioEntityDao.countByAudioId(id));
    final playlistAudioRelCount = await wrapWithResult(() => _playlistAudioEntityDao.countByAudioId(id));
    if (userAudioRelCount.isErr || playlistAudioRelCount.isErr) {
      return EmptyResult.err();
    }

    // don't delete if audio is used by user or playlist
    if (userAudioRelCount.dataOrThrow > 0 || playlistAudioRelCount.dataOrThrow > 0) {
      return EmptyResult.success();
    }

    final localAudioPath = audio.localPath;
    if (localAudioPath.notNullOrEmpty) {
      await File(localAudioPath!).delete();
    }

    final localThumbnailPath = audio.localThumbnailPath;
    if (localThumbnailPath.notNullOrEmpty) {
      await File(localThumbnailPath!).delete();
    }

    return EmptyResult.success();
  }

  @override
  Future<EmptyResult> deleteByIds(List<String> ids) async {
    for (final id in ids) {
      final res = await deleteById(id);

      if (res.isErr) {
        return EmptyResult.err();
      }
    }

    return EmptyResult.success();
  }
}
