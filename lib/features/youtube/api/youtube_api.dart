import 'package:common_models/common_models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_music_home_dto.dart';

abstract interface class YoutubeApi {
  Future<List<Video>> search(String query);

  Future<Either<FetchFailure, YoutubeMusicHomeDto>> getMusicHome();

  Future<List<String>> searchSuggestions(String query);
}
