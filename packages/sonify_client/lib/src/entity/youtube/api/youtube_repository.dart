import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_search_suggestions.dart';

abstract interface class YoutubeRepository {
  Future<Either<FetchFailure, String>> getYoutubeMusicUrl(String videoId);

  Future<Either<FetchFailure, YoutubeSearchSuggestions>> getYoutubeSuggestions(String keyword);

  Future<List<Video>> search(String query);

  Future<UnmodifiableListView<AudioOnlyStreamInfo>> getAudioOnlyStreams(String videoId);

  Future<MuxedStreamInfo> getHighestQualityMuxedStreamInfo(String videoId);

  Future<Video> getVideo(String videoId);
}
