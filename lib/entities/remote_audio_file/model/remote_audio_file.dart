import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_audio_file.freezed.dart';

@freezed
class RemoteAudioFile with _$RemoteAudioFile {
  const factory RemoteAudioFile({
    required String title,
    required Uri uri,
    required int sizeInKb,
    required String author,
  }) = _RemoteAudioFile;
}
