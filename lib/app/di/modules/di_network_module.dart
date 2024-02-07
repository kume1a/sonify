import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

const Duration _kTimeoutDuration = Duration(hours: 2);

@module
abstract class DiNetworkModule {
  @lazySingleton
  YoutubeExplode get youtubeExplode => YoutubeExplode();
}
