import 'package:common_utilities/common_utilities.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class DiUtilModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  EventBus get eventBus => EventBus();
}
