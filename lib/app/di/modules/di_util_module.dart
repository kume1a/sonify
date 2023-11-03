import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class DiUtilModule {
  @lazySingleton
  Uuid get uuid => const Uuid();
}
