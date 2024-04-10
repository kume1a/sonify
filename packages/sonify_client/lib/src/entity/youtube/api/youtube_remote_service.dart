import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../shared/dto/url_dto.dart';
import '../model/youtube_search_suggestions_dto.dart';

abstract interface class YoutubeRemoteService {
  Future<Either<FetchFailure, UrlDto>> getYoutubeMusicUrl(String videoId);

  Future<Either<FetchFailure, YoutubeSearchSuggestionsDto>> getYoutubeSuggestions(String keyword);

  Future<Either<FetchFailure, List<Video>>> search(String query);

  Future<Either<FetchFailure, UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams(String videoId);

  Future<Either<FetchFailure, MuxedStreamInfo>> getHighestQualityMuxedStreamInfo(String videoId);

  Future<Either<FetchFailure, Video>> getVideo(String videoId);
}
