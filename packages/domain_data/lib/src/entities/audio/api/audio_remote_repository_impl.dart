import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../user_audio/model/user_audio.dart';
import '../../user_audio/util/user_audio_mapper.dart';
import 'audio_remote_repository.dart';

class AudioRemoteRepositoryImpl implements AudioRemoteRepository {
  AudioRemoteRepositoryImpl(
    this._audioRemoteService,
    this._userAudioMapper,
  );

  final AudioRemoteService _audioRemoteService;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Either<UploadUserLocalMusicError, UserAudio>> uploadUserLocalMusic({
    required String localId,
    required String title,
    required String? author,
    required int? durationMs,
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

    return res.map(_userAudioMapper.dtoToModel);
  }
}
