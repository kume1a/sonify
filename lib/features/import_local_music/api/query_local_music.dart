import 'package:common_models/common_models.dart';

import '../model/local_music.dart';

abstract interface class QueryLocalMusic {
  Future<Either<ActionFailure, List<LocalMusic>>> call();
}
