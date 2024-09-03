import 'dart:collection';

import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
  );

  final YoutubeRemoteService _youtubeRemoteService;
  final YoutubeSearchSuggestionsMapper _youtubeSearchSuggestionsMapper;
  final UserAudioMapper _userAudioMapper;

  @override
  Future<Either<DownloadYoutubeAudioError, UserAudio>> downloadYoutubeAudio({
    required String videoId,
  }) async {
    final res = await _youtubeRemoteService.downloadYoutubeAudio(videoId: videoId);

    return res.map(_userAudioMapper.dtoToModel);
  }

  @override
  Future<Either<NetworkCallError, String>> getYoutubeMusicUrl({
    required String videoId,
  }) async {
    final res = await _youtubeRemoteService.getYoutubeMusicUrl(videoId);

    return res.map((r) => r.url);
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
  Future<Result<MuxedStreamInfo>> getHighestQualityMuxedStreamInfo({
    required String videoId,
  }) async {
    return _youtubeRemoteService.getHighestQualityMuxedStreamInfo(videoId);
  }
}
