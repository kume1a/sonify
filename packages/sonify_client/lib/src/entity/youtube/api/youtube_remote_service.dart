import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../shared/dto/url_dto.dart';
import '../model/youtube_search_suggestions_dto.dart';

abstract interface class YoutubeRemoteService {
  Future<Either<NetworkCallError, UrlDto>> getYoutubeMusicUrl(String videoId);

  Future<Either<NetworkCallError, YoutubeSearchSuggestionsDto>> getYoutubeSuggestions(String keyword);

  Future<Either<NetworkCallError, List<Video>>> search(String query);

  Future<Either<NetworkCallError, UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams(
      String videoId);

  Future<Either<NetworkCallError, MuxedStreamInfo>> getHighestQualityMuxedStreamInfo(String videoId);

  Future<Either<NetworkCallError, Video>> getVideo(String videoId);
}
