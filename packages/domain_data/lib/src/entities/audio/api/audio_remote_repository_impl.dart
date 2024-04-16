import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/index.dart';
import '../util/index.dart';
import 'audio_remote_repository.dart';

class AudioRemoteRepositoryImpl implements AudioRemoteRepository {
  AudioRemoteRepositoryImpl(
    this._audioRemoteService,
    this._userAudioMapper,
  );

  final AudioRemoteService _audioRemoteService;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Either<DownloadYoutubeAudioFailure, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  }) async {
    final res = await _audioRemoteService.downloadYoutubeAudio(videoId: videoId);

    return res.map(_userAudioMapper.fromDto);
  }

  @override
  Future<Either<UploadUserLocalMusicFailure, UserAudio>> uploadUserLocalMusic({
    required String localId,
    required String title,
    required String author,
    required int durationMs,
    required Uint8List audio,
    required Uint8List? thumbnail,
  }) async {
    final res = await _audioRemoteService.uploadUserLocalMusic(UploadUserLocalMusicParams(
      localId: localId,
      title: title,
      author: author,
      durationMs: durationMs,
      audio: audio,
      thumbnail: thumbnail,
    ));

    return res.map(_userAudioMapper.fromDto);
  }
}
