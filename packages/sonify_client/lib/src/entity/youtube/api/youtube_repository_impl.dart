import 'dart:collection';
import 'dart:convert';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../api/api_client.dart';
import '../model/youtube_music_home_dto.dart';
import '../model/youtube_search_suggestions.dart';
import '../util/youtube_music_home_dto_parser.dart';
import '../util/youtube_search_suggestions_mapper.dart';
import 'youtube_repository.dart';

class YoutubeRepositoryImpl with SafeHttpRequestWrap implements YoutubeRepository {
  YoutubeRepositoryImpl(
    this._apiClient,
    this._dio,
    this._yt,
    this._youtubeMusicHomeDtoParser,
    this._youtubeSearchSuggestionsMapper,
  );

  final ApiClient _apiClient;
  final Dio _dio;
  final YoutubeExplode _yt;
  final YoutubeMusicHomeDtoParser _youtubeMusicHomeDtoParser;
  final YoutubeSearchSuggestionsMapper _youtubeSearchSuggestionsMapper;

  static const Map<String, String> headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
  };

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
  Future<List<Video>> search(String query) async {
    return _yt.search.search(query);
  }

  @override
  Future<Either<FetchFailure, YoutubeMusicHomeDto>> getMusicHome() async {
    final Uri link = Uri.https('www.youtube.com', '/music');

    try {
      final response = await _dio.getUri(link);

      if (response.statusCode != 200) {
        return left(FetchFailure.unknown);
      }

      final searchResults = RegExp(
        r'(\"contents\":{.*?}),\"metadata\"',
        dotAll: true,
      ).firstMatch(response.data)![1]!;

      final dto = _youtubeMusicHomeDtoParser.parse(
        json.decode('{$searchResults}') as Map<String, dynamic>,
      );

      return right(dto);
    } catch (e) {
      Logger.root.severe('Error in getMusicHome: $e');
    }

    return left(FetchFailure.unknown);
  }

  @override
  Future<Video> getVideo(String videoId) {
    return _yt.videos.get(videoId);
  }

  @override
  Future<UnmodifiableListView<AudioOnlyStreamInfo>> getAudioOnlyStreams(
    String videoId,
  ) async {
    final manifest = await _yt.videos.streams.getManifest(videoId);

    return manifest.audioOnly;
  }

  @override
  Future<MuxedStreamInfo> getHighestQualityMuxedStreamInfo(
    String videoId,
  ) async {
    final manifest = await _yt.videos.streams.getManifest(videoId);

    return manifest.muxed.withHighestBitrate();
  }
}
