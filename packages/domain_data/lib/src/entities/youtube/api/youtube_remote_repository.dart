import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_search_suggestions.dart';

abstract interface class YoutubeRemoteRepository {
  Future<Either<FetchFailure, String>> getYoutubeMusicUrl({
    required String videoId,
  });

  Future<Either<FetchFailure, YoutubeSearchSuggestions>> getYoutubeSuggestions({
    required String keyword,
  });

  Future<Either<FetchFailure, List<Video>>> search({
    required String query,
  });

  Future<Either<FetchFailure, UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams({
    required String videoId,
  });

  Future<Either<FetchFailure, MuxedStreamInfo>> getHighestQualityMuxedStreamInfo({
    required String videoId,
  });

  Future<Either<FetchFailure, Video>> getVideo({
    required String videoId,
  });
}
