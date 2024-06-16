import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_user_local_music_error.freezed.dart';

@freezed
class UploadUserLocalMusicError with _$UploadUserLocalMusicError {
  const factory UploadUserLocalMusicError.unknown() = _unknown;

  const factory UploadUserLocalMusicError.network() = _network;

  const factory UploadUserLocalMusicError.alreadyUploaded() = _alreadyUploaded;
}
