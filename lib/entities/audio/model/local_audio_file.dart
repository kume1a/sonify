import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_audio_file.freezed.dart';

@freezed
class LocalAudioFile with _$LocalAudioFile {
  const factory LocalAudioFile({
    required int id,
    required String title,
    required Duration duration,
    required String path,
    required String author,
    required String userId,
    required int sizeInBytes,
    required String youtubeVideoId,
    required String? thumbnailPath,
  }) = _LocalAudioFile;
}
