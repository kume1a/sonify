import 'package:app_links/app_links.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

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
}
