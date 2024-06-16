import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_youtube_audio_body.g.dart';

part 'download_youtube_audio_body.freezed.dart';

@freezed
class DownloadYoutubeAudioBody with _$DownloadYoutubeAudioBody {
  const factory DownloadYoutubeAudioBody({
    required String videoId,
  }) = _DownloadYoutubeAudioBody;

  factory DownloadYoutubeAudioBody.fromJson(Map<String, dynamic> json) =>
      _$DownloadYoutubeAudioBodyFromJson(json);
}
