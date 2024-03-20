// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/audio/model/audio_dto.dart';
import '../entity/audio/model/download_youtube_audio_body.dart';
import '../entity/user/model/update_user_body.dart';
import '../entity/user/model/user_dto.dart';
import '../entity/youtube/model/youtube_suggestions_dto.dart';
import '../feature/auth/model/google_sign_in_body.dart';
import '../feature/auth/model/token_payload_dto.dart';
import '../shared/dto/url_dto.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // youtube ---------------------------
  @GET('/v1/youtube/musicUrl')
  Future<UrlDto> getYoutubeMusicUrl(@Query('videoId') String videoId);

  @GET('/v1/youtube/searchSuggestions')
  Future<YoutubeSuggestionsDto> getYoutubeSuggestions(@Query('keyword') String keyword);

  // audio -----------------------------
  @POST('/v1/audio/downloadYoutubeAudio')
  Future<AudioDto> downloadYoutubeAudio(@Body() DownloadYoutubeAudioBody body);

  // auth ------------------------------
  @POST('/v1/auth/googleSignIn')
  Future<TokenPayloadDto> googleSignIn(@Body() GoogleSignInBody body);

  // user ------------------------------
  @PATCH('/v1/users')
  Future<UserDto> updateUser(@Body() UpdateUserBody body);

  @GET('/v1/users/authUser')
  Future<UserDto> getAuthUser();
}
