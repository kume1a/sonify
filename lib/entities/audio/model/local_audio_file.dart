import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_audio_file.freezed.dart';

@freezed
class LocalAudioFile with _$LocalAudioFile {
  const factory LocalAudioFile({
    required int id,
    required String title,
    required String author,
    required String? imagePath,
    required String path,
    required int sizeInKb,
  }) = _LocalAudioFile;
}
