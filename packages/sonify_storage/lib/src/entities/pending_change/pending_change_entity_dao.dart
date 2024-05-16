import 'pending_change_entity.dart';

abstract interface class PendingChangeEntityDao {
  Future<String> insert(PendingChangeEntity entity);

  Future<void> deleteById(String id);

  Future<List<PendingChangeEntity>> getAllByTypes(List<String> types);
}
