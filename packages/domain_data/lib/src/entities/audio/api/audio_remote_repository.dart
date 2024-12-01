import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../user_audio/model/user_audio.dart';

abstract interface class AudioRemoteRepository {
  Future<Either<UploadUserLocalMusicError, UserAudio>> uploadUserLocalMusic({
    required String localId,
    required String title,
    required String? author,
    required int? durationMs,
    required Uint8List audio,
    required Uint8List? thumbnail,
  });
}
