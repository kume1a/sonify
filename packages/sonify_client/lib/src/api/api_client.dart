// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../module/audiolike/model/audio_like_dto.dart';
import '../module/audiolike/model/like_unlike_audio_body.dart';
import '../module/auth/model/email_sign_in_body.dart';
import '../module/auth/model/google_sign_in_body.dart';
import '../module/auth/model/token_payload_dto.dart';
import '../module/hidden_user_audio/index.dart';
import '../module/playlist/model/playlist_dto.dart';
import '../module/playlist_audio/model/create_playlist_audio_body_dto.dart';
import '../module/playlist_audio/model/delete_playlist_audio_body_dto.dart';
import '../module/playlist_audio/model/playlist_audio_dto.dart';
import '../module/server_time/model/server_time_dto.dart';
import '../module/spotify/model/authorize_spotify_body.dart';
import '../module/spotify/model/import_spotify_playlist_body.dart';
import '../module/spotify/model/refresh_spotify_token_body.dart';
import '../module/spotify/model/spotify_access_token_body.dart';
import '../module/spotify/model/spotify_refresh_token_payload_dto.dart';
import '../module/spotify/model/spotify_search_result_dto.dart';
import '../module/spotify/model/spotify_token_payload_dto.dart';
import '../module/user/model/update_user_body.dart';
import '../module/user/model/user_dto.dart';
import '../module/user_audio/model/user_audio_dto.dart';
import '../module/user_playlist/model/create_user_playlist_body.dart';
import '../module/user_playlist/model/update_user_playlist_body.dart';
import '../module/user_playlist/model/user_playlist_dto.dart';
import '../module/usersync/model/user_sync_datum_dto.dart';
import '../module/youtube/model/youtube_search_suggestions_dto.dart';
import '../shared/dto/audio_id_body.dart';
import '../shared/dto/audio_ids_body.dart';
import '../shared/dto/optional_ids_body.dart';
import '../shared/dto/required_ids_body.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/serverTime')
  Future<ServerTimeDto> getServerTime();

  // youtube ---------------------------
  @GET('/v1/youtube/searchSuggestions')
  Future<YoutubeSearchSuggestionsDto> getYoutubeSuggestions(@Query('keyword') String keyword);

  // audio like -----------------------------
  @POST('/v1/audiolike/like')
  Future<AudioLikeDto> likeAudio(@Body() LikeUnlikeAudioBody body);

  @POST('/v1/audiolike/unlike')
  Future<void> unlikeAudio(@Body() LikeUnlikeAudioBody body);

  @GET('/v1/audiolike/myLikes')
  Future<List<AudioLikeDto>?> getAuthUserAudioLikes(@Body() OptionalIdsBody body);

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

  @GET('/v1/spotify/search')
  Future<SpotifySearchResultDto> spotifySearch(
    @Query('keyword') String keyword,
    @Query('spotifyAccessToken') String spotifyAccessToken,
  );

  @POST('/v1/spotify/importUserPlaylists')
  Future<void> importSpotifyUserPlaylists(@Body() SpotifyAccessTokenBody body);

  @POST('/v1/spotify/importPlaylist')
  Future<PlaylistDto> importSpotifyPlaylist(@Body() ImportSpotifyPlaylistBody body);

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
    @Body() OptionalIdsBody body,
  );

  @GET('/v1/userplaylist/myPlaylistIds')
  Future<List<String>?> getPlaylistIdsByAuthUser();

  @GET('/v1/userplaylist/myUserPlaylistIds')
  Future<List<String>?> getUserPlaylistIdsByAuthUser();

  @POST('/v1/userplaylist')
  Future<UserPlaylistDto> createUserPlaylist(@Body() CreateUserPlaylistBody body);

  @PATCH('/v1/userplaylist/{id}')
  Future<UserPlaylistDto> updateUserPlaylistById(
    @Path('id') String id,
    UpdateUserPlaylistBody body,
  );

  @DELETE('/v1/userplaylist/{id}')
  Future<void> deleteUserPlaylistById(@Path('id') String id);

  // playlist audio ---------------------
  @GET('/v1/playlistaudio/myPlaylistAudios')
  Future<List<PlaylistAudioDto>?> getPlaylistAudiosByAuthUser(
    @Body() RequiredIdsBody body,
  );

  @GET('/v1/playlistaudio/myPlaylistAudioIds')
  Future<List<String>?> getPlaylistAudioIdsByAuthUser();

  @POST('/v1/playlistaudio')
  Future<PlaylistAudioDto> createPlaylistAudio(@Body() CreatePlaylistAudioBodyDto body);

  @DELETE('/v1/playlistaudio')
  Future<void> deletePlaylistAudio(@Body() DeletePlaylistAudioBodyDto body);

  // user audio -------------------------
  @POST('/v1/useraudio/createForAuthUser')
  Future<List<UserAudioDto>?> createUserAudiosForAuthUser(@Body() AudioIdsBody body);

  @DELETE('/v1/useraudio/deleteForAuthUser')
  Future<void> deleteUserAudioForAuthUser(@Body() AudioIdBody body);

  @GET('/v1/useraudio/myAudioIds')
  Future<List<String>?> getAuthUserAudioIds();

  @GET('/v1/useraudio/myUserAudiosByIds')
  Future<List<UserAudioDto>?> getAuthUserUserAudiosByIds(
    @Body() AudioIdsBody body, // using body for big payload
  );

  // hidden user audio -----------------
  @POST('/v1/hiddenuseraudio/hideForAuthUser')
  Future<HiddenUserAudioDto> hideUserAudioForAuthUser(@Body() AudioIdBody body);

  @POST('/v1/hiddenuseraudio/unhideForAuthUser')
  Future<void> unhideUserAudioForAuthUser(@Body() AudioIdBody body);
}
