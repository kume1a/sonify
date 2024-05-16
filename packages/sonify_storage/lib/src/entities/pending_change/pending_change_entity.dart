// add pending change entity version for migrations

class PendingChangeEntity {
  PendingChangeEntity({
    required this.id,
    required this.type,
    required this.payloadJSON,
  });

  final int? id;
  final String? type;
  final String? payloadJSON;
}
