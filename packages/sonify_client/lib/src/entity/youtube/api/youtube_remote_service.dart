import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../shared/dto/url_dto.dart';
import '../../audio/model/user_audio_dto.dart';
import '../model/download_youtube_audio_error.dart';
import '../model/youtube_search_suggestions_dto.dart';

abstract interface class YoutubeRemoteService {
  Future<Either<DownloadYoutubeAudioError, UserAudioDto>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<NetworkCallError, UrlDto>> getYoutubeMusicUrl(String videoId);

  Future<Either<NetworkCallError, YoutubeSearchSuggestionsDto>> getYoutubeSuggestions(String keyword);

  Future<Result<List<Video>>> search(String query);

  Future<Result<UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams(String videoId);

  Future<Result<MuxedStreamInfo>> getHighestQualityMuxedStreamInfo(String videoId);

  Future<Result<Video>> getVideo(String videoId);
}
