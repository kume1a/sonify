import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audio/model/audio_like.dart';

part 'pending_change.freezed.dart';

@freezed
class PendingChange with _$PendingChange {
  const factory PendingChange({
    required String? id,
    required PendingChangeType type,
    required PendingChangePayload payload,
  }) = _PendingChange;
}

enum PendingChangeType {
  createLike,
  deleteLike,
}

@freezed
class PendingChangePayload with _$PendingChangePayload {
  const factory PendingChangePayload.createLike(AudioLike audioLike) = _createLike;

  const factory PendingChangePayload.deleteLike(AudioLike audioLike) = _deleteLike;
}
