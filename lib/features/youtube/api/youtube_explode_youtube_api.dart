import 'dart:convert';

import 'package:common_models/common_models.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_music_home_dto.dart';
import '../util/youtube_music_home_dto_parser.dart';
import 'youtube_api.dart';

@LazySingleton(as: YoutubeApi)
class YoutubeExplodeYouTubeApi implements YoutubeApi {
  YoutubeExplodeYouTubeApi(
    this._yt,
    this._youtubeMusicHomeDtoParser,
  );

  final YoutubeExplode _yt;
  final YoutubeMusicHomeDtoParser _youtubeMusicHomeDtoParser;

  static const searchAuthority = 'www.youtube.com';
  @override
  Future<List<Video>> search(String query) async {
    return _yt.search.search(query);
  }

  @override
  Future<Either<FetchFailure, YoutubeMusicHomeDto>> getMusicHome() async {
    final Uri link = Uri.https(searchAuthority, '/music');

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
}
