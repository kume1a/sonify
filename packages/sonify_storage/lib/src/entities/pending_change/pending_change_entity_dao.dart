import 'pending_change_entity.dart';

abstract interface class PendingChangeEntityDao {
  Future<void> insert(PendingChangeEntity entity);

  Future<void> deleteById(int id);

  Future<List<PendingChangeEntity>> getAllByTypes(List<String> types);
}
