import 'package:common_models/common_models.dart';

import '../util/sync_entity_base.dart';

abstract interface class SyncUserAudio {
  Future<Result<SyncEntitiesResult>> call();
}
