import '../../db/tables.dart';
import 'pending_change_entity.dart';

class PendingChangeEntityMapper {
  PendingChangeEntity mapToEntity(Map<String, dynamic> m) {
    return PendingChangeEntity(
      id: m[PendingChange_.id] as int?,
      type: m[PendingChange_.type],
      payloadJSON: m[PendingChange_.payloadJSON],
    );
  }

  Map<String, dynamic> entityToMap(PendingChangeEntity e) {
    return <String, dynamic>{
      PendingChange_.id: e.id,
      PendingChange_.type: e.type,
      PendingChange_.payloadJSON: e.payloadJSON,
    };
  }
}
