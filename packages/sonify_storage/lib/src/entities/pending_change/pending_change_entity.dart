// add pending change entity version for migrations

import '../../shared/wrapped.dart';

class PendingChangeEntity {
  PendingChangeEntity({
    required this.id,
    required this.type,
    required this.payloadJSON,
  });

  final String? id;
  final String? type;
  final String? payloadJSON;

  PendingChangeEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<String?>? type,
    Wrapped<String?>? payloadJSON,
  }) {
    return PendingChangeEntity(
      id: id?.value ?? this.id,
      type: type?.value ?? this.type,
      payloadJSON: payloadJSON?.value ?? this.payloadJSON,
    );
  }
}
