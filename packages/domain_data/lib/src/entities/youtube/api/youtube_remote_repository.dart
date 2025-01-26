import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../user_audio/model/user_audio.dart';
import '../model/youtube_search_suggestions.dart';

abstract interface class YoutubeRemoteRepository {
  Future<Either<DownloadYoutubeAudioError, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  });

  Future<Either<NetworkCallError, String>> getYoutubeMusicUrl({
    required String videoId,
  });

  Future<Either<NetworkCallError, YoutubeSearchSuggestions>> getYoutubeSuggestions({
    required String keyword,
  });

  Future<Result<List<Video>>> search({
    required String query,
  });

  Future<Result<UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams({
    required String videoId,
  });

  Future<Result<VideoStreamInfo>> getHighestQualityStreamInfo({
    required String videoId,
  });

  Future<Result<Video>> getVideo({
    required String videoId,
  });
}
