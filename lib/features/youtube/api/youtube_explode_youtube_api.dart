import 'dart:collection';
import 'dart:convert';

import 'package:common_models/common_models.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_music_home_dto.dart';
import '../model/youtube_search_suggestions.dart';
import '../util/youtube_music_home_dto_parser.dart';
import '../util/youtube_search_suggestions_mapper.dart';
import 'youtube_api.dart';

@LazySingleton(as: YoutubeApi)
class YoutubeExplodeYouTubeApi implements YoutubeApi {
  YoutubeExplodeYouTubeApi(
    this._yt,
    this._youtubeMusicHomeDtoParser,
    this._youtubeSearchSuggestionsMapper,
  );

  final YoutubeExplode _yt;
  final YoutubeMusicHomeDtoParser _youtubeMusicHomeDtoParser;
  final YoutubeSearchSuggestionsMapper _youtubeSearchSuggestionsMapper;

  static const Map<String, String> headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
  };

  @override
  Future<List<Video>> search(String query) async {
    return _yt.search.search(query);
  }

  @override
  Future<Either<FetchFailure, YoutubeMusicHomeDto>> getMusicHome() async {
    final Uri link = Uri.https('www.youtube.com', '/music');

    try {
      final response = await http.get(link);

      if (response.statusCode != 200) {
        return left(FetchFailure.unknown);
      }

      final searchResults = RegExp(
        r'(\"contents\":{.*?}),\"metadata\"',
        dotAll: true,
      ).firstMatch(response.body)![1]!;

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
  Future<YoutubeSearchSuggestions> searchSuggestions(String query) async {
    final link = Uri.parse('https://invidious.slipfox.xyz/api/v1/search/suggestions?q=$query');

    try {
      final response = await http.get(link, headers: headers);
      if (response.statusCode != 200) {
        return YoutubeSearchSuggestions.empty();
      }

      final res = json.decode(response.body) as Map<String, dynamic>;

      return _youtubeSearchSuggestionsMapper.jsonToModel(res);
    } catch (e) {
      Logger.root.severe('Error in getSearchSuggestions: $e');
    }

    return YoutubeSearchSuggestions.empty();
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
