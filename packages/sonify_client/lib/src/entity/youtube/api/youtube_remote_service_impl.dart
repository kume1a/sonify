import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../api/api_client.dart';
import '../../../shared/dto/url_dto.dart';
import '../model/youtube_search_suggestions_dto.dart';
import 'youtube_remote_service.dart';

class YoutubeRemoteServiceImpl with SafeHttpRequestWrap implements YoutubeRemoteService {
  YoutubeRemoteServiceImpl(
    this._apiClient,
    this._yt,
  );

  final ApiClient _apiClient;
  final YoutubeExplode _yt;

  @override
  Future<Either<FetchFailure, UrlDto>> getYoutubeMusicUrl(String videoId) {
    return callCatchWithFetchFailure(
      () => _apiClient.getYoutubeMusicUrl(videoId),
    );
  }

  @override
  Future<Either<FetchFailure, YoutubeSearchSuggestionsDto>> getYoutubeSuggestions(String keyword) async {
    return callCatchWithFetchFailure(
      () => _apiClient.getYoutubeSuggestions(keyword),
    );
  }

  @override
  Future<Either<FetchFailure, List<Video>>> search(String query) async {
    try {
      final videos = await _yt.search.search(query);

      return right(videos);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.search $e');
    }

    return left(FetchFailure.unknown);
  }

  @override
  Future<Either<FetchFailure, Video>> getVideo(String videoId) async {
    try {
      final video = await _yt.videos.get(videoId);

      return right(video);
    } catch (e) {
      Logger.root.severe('YoutubeRepositoryImpl.getVideo $e');
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
      Logger.root.severe('YoutubeRepositoryImpl.getAudioOnlyStreams $e');
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
      Logger.root.severe('YoutubeRepositoryImpl.getHighestQualityMuxedStreamInfo, $e');
    }

    return left(FetchFailure.unknown);
  }
}
