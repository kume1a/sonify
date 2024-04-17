import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_youtube_audio_error.freezed.dart';

@freezed
class DownloadYoutubeAudioError with _$DownloadYoutubeAudioError {
  const factory DownloadYoutubeAudioError.network() = _network;

  const factory DownloadYoutubeAudioError.unknown() = _unknown;

  const factory DownloadYoutubeAudioError.alreadyDownloaded() = _alreadyDownloaded;
}
