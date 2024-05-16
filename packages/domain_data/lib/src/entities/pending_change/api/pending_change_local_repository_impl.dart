import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../model/pending_change.dart';
import '../util/pending_change_mapper.dart';
import 'pending_change_local_repository.dart';

class PendingChangeLocalRepositoryImpl with ResultWrap implements PendingChangeLocalRepository {
  PendingChangeLocalRepositoryImpl(
    this._pendingChangeEntityDao,
    this._pendingChangeMapper,
  );

  final PendingChangeEntityDao _pendingChangeEntityDao;
  final PendingChangeMapper _pendingChangeMapper;

  @override
  Future<EmptyResult> create(PendingChange pendingChange) {
    return wrapWithEmptyResult(
      () => _pendingChangeEntityDao.insert(_pendingChangeMapper.modelToEntity(pendingChange)),
    );
  }

  @override
  Future<EmptyResult> deleteById(String id) {
    return wrapWithEmptyResult(() => _pendingChangeEntityDao.deleteById(id));
  }

  @override
  Future<Result<List<PendingChange>>> getAllByTypes(List<PendingChangeType> types) {
    return wrapWithResult(() async {
      final typeStrings = types.map((e) => e.name).toList();

      final res = await _pendingChangeEntityDao.getAllByTypes(typeStrings);

      return res.map(_pendingChangeMapper.entityToModel).toList();
    });
  }
}
