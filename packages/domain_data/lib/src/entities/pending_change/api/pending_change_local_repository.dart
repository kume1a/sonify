import 'package:common_models/common_models.dart';

import '../model/pending_change.dart';

abstract interface class PendingChangeLocalRepository {
  Future<EmptyResult> create(PendingChange pendingChange);

  Future<EmptyResult> deleteById(String id);

  Future<Result<List<PendingChange>>> getAllByTypes(List<PendingChangeType> types);
}
