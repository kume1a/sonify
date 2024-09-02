import 'package:app_links/app_links.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

@module
abstract class DiUtilModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  EventBus get eventBus => EventBus();

  @lazySingleton
  AppLinks get appLinks => AppLinks();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfo();

  @lazySingleton
  YoutubeExplode get youtubeExplode => YoutubeExplode();
}
