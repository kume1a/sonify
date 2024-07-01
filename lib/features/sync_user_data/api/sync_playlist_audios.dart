import 'package:common_models/common_models.dart';

import '../util/sync_entity_base.dart';

abstract interface class SyncPlaylistAudios {
  Future<Result<SyncEntitiesResult>> call();
}
