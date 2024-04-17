import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_search_suggestions.dart';

abstract interface class YoutubeRemoteRepository {
  Future<Either<NetworkCallError, String>> getYoutubeMusicUrl({
    required String videoId,
  });

  Future<Either<NetworkCallError, YoutubeSearchSuggestions>> getYoutubeSuggestions({
    required String keyword,
  });

  Future<Either<NetworkCallError, List<Video>>> search({
    required String query,
  });

  Future<Either<NetworkCallError, UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams({
    required String videoId,
  });

  Future<Either<NetworkCallError, MuxedStreamInfo>> getHighestQualityMuxedStreamInfo({
    required String videoId,
  });

  Future<Either<NetworkCallError, Video>> getVideo({
    required String videoId,
  });
}
