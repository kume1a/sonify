import 'dart:convert';

import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../../audiolike/model/audio_like.dart';
import '../model/pending_change.dart';

class PendingChangeMapper {
  static const _audioLikeLocalId = 'localId';
  static const _audioLikeAudioId = 'audioId';
  static const _audioLikeUserId = 'userId';

  PendingChange entityToModel(PendingChangeEntity e) {
    return PendingChange(
      id: e.id ?? kInvalidId,
      type: PendingChangeType.values.byName(e.type ?? ''),
      payload: _payloadFromJSON(e),
    );
  }

  PendingChangeEntity modelToEntity(PendingChange m) {
    return PendingChangeEntity(
      id: m.id,
      type: m.type.name,
      payloadJSON: _payloadToJSON(m.payload),
    );
  }

  PendingChangePayload _payloadFromJSON(PendingChangeEntity e) {
    final Map<String, dynamic> payloadJSON = jsonDecode(e.payloadJSON ?? '{}');

    final type = PendingChangeType.values.byName(e.type ?? '');

    return switch (type) {
      PendingChangeType.createLike => PendingChangePayload.createLike(_audioLikeJSONToModel(payloadJSON)),
      PendingChangeType.deleteLike => PendingChangePayload.deleteLike(_audioLikeJSONToModel(payloadJSON)),
    };
  }

  String _payloadToJSON(PendingChangePayload payload) {
    final map = payload.when(
      createLike: _audioLikeToJSON,
      deleteLike: _audioLikeToJSON,
    );

    return jsonEncode(map);
  }

  AudioLike _audioLikeJSONToModel(Map<String, dynamic> json) {
    return AudioLike(
      id: json[_audioLikeLocalId] as String?,
      audioId: json[_audioLikeAudioId] as String?,
      userId: json[_audioLikeUserId] as String?,
    );
  }

  Map<String, dynamic> _audioLikeToJSON(AudioLike model) {
    return {
      _audioLikeLocalId: model.id,
      _audioLikeAudioId: model.audioId,
      _audioLikeUserId: model.userId,
    };
  }
}
