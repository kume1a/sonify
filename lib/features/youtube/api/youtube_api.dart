import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_music_home_dto.dart';
import '../model/youtube_search_suggestions.dart';

abstract interface class YoutubeApi {
  Future<List<Video>> search(String query);

  Future<Either<FetchFailure, YoutubeMusicHomeDto>> getMusicHome();

  Future<YoutubeSearchSuggestions> searchSuggestions(String query);

  Future<MuxedStreamInfo> getVideoStream(String videoId);
}
