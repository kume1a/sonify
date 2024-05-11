import 'package:sqflite/sqflite.dart';

import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import 'pending_change_entity.dart';
import 'pending_change_entity_dao.dart';
import 'pending_change_entity_mapper.dart';

class SqflitePendingChangeEntityDao implements PendingChangeEntityDao {
  SqflitePendingChangeEntityDao(
    this._db,
    this._pendingChangeEntityMapper,
  );

  final Database _db;
  final PendingChangeEntityMapper _pendingChangeEntityMapper;

  @override
  Future<void> insert(PendingChangeEntity entity) {
    return _db.insert(
      PendingChange_.tn,
      _pendingChangeEntityMapper.entityToMap(entity),
    );
  }

  @override
  Future<void> deleteById(int id) {
    return _db.delete(
      PendingChange_.tn,
      where: '${PendingChange_.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PendingChangeEntity>> getAllByTypes(List<String> types) async {
    final query = await _db.query(
      PendingChange_.tn,
      where: '${PendingChange_.type} IN ${sqlListPlaceholders(types.length)}',
      whereArgs: types,
      orderBy: '${PendingChange_.id} ASC',
    );

    return query.map(_pendingChangeEntityMapper.mapToEntity).toList();
  }
}
