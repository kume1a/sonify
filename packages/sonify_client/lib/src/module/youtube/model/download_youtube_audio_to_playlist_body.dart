import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_youtube_audio_to_playlist_body.g.dart';

part 'download_youtube_audio_to_playlist_body.freezed.dart';

@freezed
class DownloadYoutubeAudioToPlaylistBody with _$DownloadYoutubeAudioToPlaylistBody {
  const factory DownloadYoutubeAudioToPlaylistBody({
    required String videoId,
    required String playlistId,
  }) = _DownloadYoutubeAudioToPlaylistBody;

  factory DownloadYoutubeAudioToPlaylistBody.fromJson(Map<String, dynamic> json) =>
      _$DownloadYoutubeAudioToPlaylistBodyFromJson(json);
}
