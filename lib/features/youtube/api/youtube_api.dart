import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeApi {
  final YoutubeExplode yt = YoutubeExplode();

  Future<List<Video>> search(String query) async {
    return yt.search.search(query);
  }
}
