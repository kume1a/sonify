import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../api/api_client.dart';
import '../model/youtube_search_suggestions.dart';
import '../util/youtube_search_suggestions_mapper.dart';
import 'youtube_repository.dart';

class YoutubeRepositoryImpl with SafeHttpRequestWrap implements YoutubeRepository {
  YoutubeRepositoryImpl(
    this._apiClient,
    this._yt,
    this._youtubeSearchSuggestionsMapper,
  );

  final ApiClient _apiClient;
  final YoutubeExplode _yt;
  final YoutubeSearchSuggestionsMapper _youtubeSearchSuggestionsMapper;

  @override
  Future<Either<FetchFailure, String>> getYoutubeMusicUrl(String videoId) {
    return callCatchWithFetchFailure(
      () async {
        final res = await _apiClient.getYoutubeMusicUrl(videoId);

        return res.url;
      },
    );
  }

  @override
  Future<Either<FetchFailure, YoutubeSearchSuggestions>> getYoutubeSuggestions(String keyword) async {
    return callCatchWithFetchFailure(
      () async {
        final res = await _apiClient.getYoutubeSuggestions(keyword);

        return _youtubeSearchSuggestionsMapper.dtoToModel(res);
      },
    );
  }

  @override
  Future<Either<FetchFailure, List<Video>>> search(String query) async {
    try {
      final videos = await _yt.search.search(query);

      return right(videos);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.search', e);
    }

    return left(FetchFailure.unknown);
  }

  @override
  Future<Either<FetchFailure, Video>> getVideo(String videoId) async {
    try {
      final video = await _yt.videos.get(videoId);

      return right(video);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.getVideo', e);
    }

    return left(FetchFailure.unknown);
  }

  @override
  Future<Either<FetchFailure, UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams(
    String videoId,
  ) async {
    try {
      final manifest = await _yt.videos.streams.getManifest(videoId);

      return right(manifest.audioOnly);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.getAudioOnlyStreams', e);
    }

    return left(FetchFailure.unknown);
  }

  @override
  Future<Either<FetchFailure, MuxedStreamInfo>> getHighestQualityMuxedStreamInfo(
    String videoId,
  ) async {
    try {
      final manifest = await _yt.videos.streams.getManifest(videoId);
      final streamInfo = manifest.muxed.withHighestBitrate();

      return right(streamInfo);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.getHighestQualityMuxedStreamInfo', e);
    }

    return left(FetchFailure.unknown);
  }
}
