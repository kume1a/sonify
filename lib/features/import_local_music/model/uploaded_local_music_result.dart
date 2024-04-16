import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sonify_client/sonify_client.dart';

import 'local_music.dart';

part 'uploaded_local_music_result.freezed.dart';

@freezed
class UploadedLocalMusicResult with _$UploadedLocalMusicResult {
  const factory UploadedLocalMusicResult({
    required LocalMusic localMusic,
    required UploadUserLocalMusicFailure? failure,
  }) = _UploadedLocalMusicResult;
}
