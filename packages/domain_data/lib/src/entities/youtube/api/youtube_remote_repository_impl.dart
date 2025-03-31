import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../playlist_audio/model/playlist_audio.dart';
import '../../playlist_audio/util/playlist_audio_mapper.dart';
import '../../user_audio/model/user_audio.dart';
import '../../user_audio/util/user_audio_mapper.dart';
import '../model/youtube_search_suggestions.dart';
import '../util/youtube_search_suggestions_mapper.dart';
import 'youtube_remote_repository.dart';

class YoutubeRemoteRepositoryImpl with SafeHttpRequestWrap implements YoutubeRemoteRepository {
  YoutubeRemoteRepositoryImpl(
    this._youtubeRemoteService,
    this._youtubeSearchSuggestionsMapper,
    this._userAudioMapper,
    this._playlistAudioMapper,
  );

  final YoutubeRemoteService _youtubeRemoteService;
  final YoutubeSearchSuggestionsMapper _youtubeSearchSuggestionsMapper;
  final UserAudioMapper _userAudioMapper;
  final PlaylistAudioMapper _playlistAudioMapper;

  @override
  Future<Either<DownloadYoutubeAudioError, UserAudio>> downloadYoutubeAudioToUserLibrary({
    required String videoId,
  }) async {
    final res = await _youtubeRemoteService.downloadYoutubeAudioToUserLibrary(videoId: videoId);

    return res.map(_userAudioMapper.dtoToModel);
  }

  @override
  Future<Either<DownloadYoutubeAudioError, PlaylistAudio>> downloadYoutubeAudioToPlaylist({
    required String videoId,
    required String playlistId,
  }) async {
    final res = await _youtubeRemoteService.downloadYoutubeAudioToPlaylist(
      videoId: videoId,
      playlistId: playlistId,
    );

    return res.map(_playlistAudioMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, YoutubeSearchSuggestions>> getYoutubeSuggestions({
    required String keyword,
  }) async {
    final res = await _youtubeRemoteService.getYoutubeSuggestions(keyword);

    return res.map(_youtubeSearchSuggestionsMapper.dtoToModel);
  }

  @override
  Future<Result<List<Video>>> search({
    required String query,
  }) async {
    return _youtubeRemoteService.search(query);
  }

  @override
  Future<Result<Video>> getVideo({
    required String videoId,
  }) async {
    return _youtubeRemoteService.getVideo(videoId);
  }

  @override
  Future<Result<UnmodifiableListView<AudioOnlyStreamInfo>>> getAudioOnlyStreams({
    required String videoId,
  }) async {
    return _youtubeRemoteService.getAudioOnlyStreams(videoId);
  }

  @override
  Future<Result<VideoStreamInfo>> getHighestQualityStreamInfo({
    required String videoId,
  }) async {
    return _youtubeRemoteService.getHighestQualityStreamInfo(videoId);
  }
}
