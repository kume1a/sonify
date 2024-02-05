// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/youtubemusic/model/youtube_suggestions_dto.dart';
import '../shared/entity/url_dto.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/youtubeMusic/musicUrl')
  Future<UrlDto> getYoutubeMusicUrl(@Query('videoId') String videoId);

  @GET('/youtubeMusic/searchSuggestions')
  Future<YoutubeSuggestionsDto> getYoutubeMusicSuggestions(@Query('keyword') String keyword);
}
