import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_youtube_audio_failure.freezed.dart';

@freezed
class DownloadYoutubeAudioFailure with _$DownloadYoutubeAudioFailure {
  const factory DownloadYoutubeAudioFailure.network() = _network;

  const factory DownloadYoutubeAudioFailure.unknown() = _unknown;

  const factory DownloadYoutubeAudioFailure.alreadyDownloaded() = _alreadyDownloaded;
}
