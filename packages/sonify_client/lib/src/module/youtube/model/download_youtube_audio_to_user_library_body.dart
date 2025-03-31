import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_youtube_audio_to_user_library_body.g.dart';

part 'download_youtube_audio_to_user_library_body.freezed.dart';

@freezed
class DownloadYoutubeAudioToUserLibraryBody with _$DownloadYoutubeAudioToUserLibraryBody {
  const factory DownloadYoutubeAudioToUserLibraryBody({
    required String videoId,
  }) = _DownloadYoutubeAudioToUserLibraryBody;

  factory DownloadYoutubeAudioToUserLibraryBody.fromJson(Map<String, dynamic> json) =>
      _$DownloadYoutubeAudioToUserLibraryBodyFromJson(json);
}
