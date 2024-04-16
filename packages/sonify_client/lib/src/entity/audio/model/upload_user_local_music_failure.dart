import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_user_local_music_failure.freezed.dart';

@freezed
class UploadUserLocalMusicFailure with _$UploadUserLocalMusicFailure {
  const factory UploadUserLocalMusicFailure.unknown() = _unknown;

  const factory UploadUserLocalMusicFailure.network() = _network;

  const factory UploadUserLocalMusicFailure.alreadyUploaded() = _alreadyUploaded;
}
