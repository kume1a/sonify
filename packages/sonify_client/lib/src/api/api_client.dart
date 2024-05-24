// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/audio/model/audio_ids_body.dart';
import '../entity/audio/model/audio_like_dto.dart';
import '../entity/audio/model/get_audio_likes_body.dart';
import '../entity/audio/model/like_audio_body.dart';
import '../entity/audio/model/unlike_audio_body.dart';
import '../entity/audio/model/user_audio_dto.dart';
import '../entity/playlist/model/playlist_dto.dart';
import '../entity/server_time/model/server_time_dto.dart';
import '../entity/user/model/update_user_body.dart';
import '../entity/user/model/user_dto.dart';
import '../entity/usersync/model/user_sync_datum_dto.dart';
import '../entity/youtube/model/youtube_search_suggestions_dto.dart';
import '../feature/auth/model/email_sign_in_body.dart';
import '../feature/auth/model/google_sign_in_body.dart';
import '../feature/auth/model/token_payload_dto.dart';
import '../feature/spotifyauth/model/authorize_spotify_body.dart';
import '../feature/spotifyauth/model/refresh_spotify_token_body.dart';
import '../feature/spotifyauth/model/spotify_refresh_token_payload_dto.dart';
import '../feature/spotifyauth/model/spotify_token_payload_dto.dart';
import '../shared/dto/url_dto.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/serverTime')
  Future<ServerTimeDto> getServerTime();

  // youtube ---------------------------
  @GET('/v1/youtube/musicUrl')
  Future<UrlDto> getYoutubeMusicUrl(@Query('videoId') String videoId);

  @GET('/v1/youtube/searchSuggestions')
  Future<YoutubeSearchSuggestionsDto> getYoutubeSuggestions(@Query('keyword') String keyword);

  // audio -----------------------------
  @GET('/v1/audio/myAudioIds')
  Future<List<String>?> getAuthUserAudioIds();

  @GET('/v1/audio/myUserAudiosByIds')
  Future<List<UserAudioDto>?> getAuthUserUserAudiosByIds(
    @Body() AudioIdsBody body, // using body for big payload
  );

  @POST('/v1/audio/like')
  Future<AudioLikeDto> likeAudio(@Body() LikeAudioBody body);

  @POST('/v1/audio/unlike')
  Future<void> unlikeAudio(@Body() UnlikeAudioBody body);

  @GET('/v1/audio/myLikes')
  Future<List<AudioLikeDto>?> getAuthUserAudioLikes(@Body() GetAudioLikesBody body);

  // auth ------------------------------
  @POST('/v1/auth/googleSignIn')
  Future<TokenPayloadDto> googleSignIn(@Body() GoogleSignInBody body);

  @POST('/v1/auth/emailSignIn')
  Future<TokenPayloadDto> emailSignIn(@Body() EmailSignInBody body);

  // user ------------------------------
  @PATCH('/v1/users/update')
  Future<UserDto> updateAuthUser(@Body() UpdateUserBody body);

  @GET('/v1/users/authUser')
  Future<UserDto> getAuthUser();

  // spotify ---------------------------
  @POST('/v1/spotify/authorize')
  Future<SpotifyTokenPayloadDto> authorizeSpotify(@Body() AuthorizeSpotifyBody body);

  @POST('/v1/spotify/refreshToken')
  Future<SpotifyRefreshTokenPayloadDto> refreshSpotifyToken(@Body() RefreshSpotifyTokenBody body);

  @POST('/v1/spotify/importUserPlaylists')
  Future<void> importSpotifyUserPlaylists(
    @Query('spotifyAccessToken') String spotifyAccessToken,
  );

  // user sync --------------------------
  @GET('/v1/usersync/myUserSyncDatum')
  Future<UserSyncDatumDto> getAuthUserSyncDatum();

  @POST('/v1/usersync/markUserAudioLastUpdatedAtAsNow')
  Future<void> markAuthUserAudioLastUpdatedAtAsNow();

  @GET('/v1/userplaylist/myPlaylists')
  Future<List<PlaylistDto>?> getAuthUserPlaylists(
    @Query('ids') List<String>? ids,
  );

  @GET('/v1/userplaylist/myPlaylistIds')
  Future<List<String>?> getAuthUserPlaylistIds();

  // playlist ---------------------------
  @GET('/v1/playlists/{playlistId}')
  Future<PlaylistDto> getPlaylistById(
    @Path('playlistId') String playlistId,
  );
}
