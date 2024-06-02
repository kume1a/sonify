// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/audio/model/audio_ids_body.dart';
import '../entity/audio/model/user_audio_dto.dart';
import '../entity/audiolike/model/audio_like_dto.dart';
import '../entity/audiolike/model/get_audio_likes_body.dart';
import '../entity/audiolike/model/like_unlike_audio_body.dart';
import '../entity/playlist/model/playlist_dto.dart';
import '../entity/playlist_audio/model/playlist_audio_dto.dart';
import '../entity/server_time/model/server_time_dto.dart';
import '../entity/user/model/update_user_body.dart';
import '../entity/user/model/user_dto.dart';
import '../entity/user_playlist/model/user_playlist_dto.dart';
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

  @POST('/v1/audiolike/like')
  Future<AudioLikeDto> likeAudio(@Body() LikeUnlikeAudioBody body);

  @POST('/v1/audiolike/unlike')
  Future<void> unlikeAudio(@Body() LikeUnlikeAudioBody body);

  @GET('/v1/audiolike/myLikes')
  Future<List<AudioLikeDto>?> getAuthUserAudioLikes(@Body() GetAudioLikesBody body);

  // auth ------------------------------
  @POST('/v1/auth/googleSignIn')
  Future<TokenPayloadDto> googleSignIn(@Body() GoogleSignInBody body);

  @POST('/v1/auth/emailSignIn')
  Future<TokenPayloadDto> emailSignIn(@Body() EmailSignInBody body);

  // user ------------------------------
  @PATCH('/v1/users/updateMe')
  Future<UserDto> updateAuthUser(@Body() UpdateUserBody body);

  @GET('/v1/users/authUser')
  Future<UserDto> getAuthUser();

  // spotify ---------------------------
  @POST('/v1/spotify/authorize')
  Future<SpotifyTokenPayloadDto> authorizeSpotify(@Body() AuthorizeSpotifyBody body);

  @POST('/v1/spotify/refreshToken')
  Future<SpotifyRefreshTokenPayloadDto> refreshSpotifyToken(@Body() RefreshSpotifyTokenBody body);

  // user sync --------------------------
  @GET('/v1/usersync/myUserSyncDatum')
  Future<UserSyncDatumDto> getAuthUserSyncDatum();

  @POST('/v1/usersync/markUserAudioLastUpdatedAtAsNow')
  Future<void> markAuthUserAudioLastUpdatedAtAsNow();

  // playlist ---------------------------
  @GET('/v1/playlists/{playlistId}')
  Future<PlaylistDto> getPlaylistById(
    @Path('playlistId') String playlistId,
  );

  // user playlist
  @GET('/v1/userplaylist/myUserPlaylists/full')
  Future<List<UserPlaylistDto>?> getUserPlaylistsFullByAuthUser(
    @Query('playlistIds') List<String>? playlistIds,
  );

  @GET('/v1/userplaylist/myUserPlaylists')
  Future<List<UserPlaylistDto>?> getUserPlaylistsByAuthUser(
    @Query('ids') List<String>? ids,
  );

  @GET('/v1/userplaylist/myPlaylistIds')
  Future<List<String>?> getPlaylistIdsByAuthUser();

  @GET('/v1/userplaylist/myUserPlaylistIds')
  Future<List<String>?> getUserPlaylistIdsByAuthUser();

  // playlist audio ---------------------
  @GET('/v1/playlistaudio/myPlaylistAudios')
  Future<List<PlaylistAudioDto>?> getPlaylistAudiosByAuthUser(
    @Query('ids') List<String> ids,
  );

  @GET('/v1/playlistaudio/myPlaylistAudioIdsByAuthUser')
  Future<List<String>?> getPlaylistAudioIdsByAuthUser();
}
