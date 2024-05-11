import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/playlist_audio.dart';

class PlaylistAudioMapper {
  PlaylistAudio dtoToModel(PlaylistAudioDto dto) {
    return PlaylistAudio(
      localId: null,
      createdAt: tryMapDate(dto.createdAt),
      audioId: dto.audioId ?? kInvalidId,
      playlistId: dto.playlistId ?? kInvalidId,
    );
  }

  PlaylistAudio entityToModel(PlaylistAudioEntity entity) {
    return PlaylistAudio(
      localId: entity.id,
      createdAt: tryMapDateMillis(entity.bCreatedAtMillis),
      audioId: entity.bAudioId ?? kInvalidId,
      playlistId: entity.bPlaylistId ?? kInvalidId,
    );
  }

  PlaylistAudioEntity modelToEntity(PlaylistAudio model) {
    return PlaylistAudioEntity(
      id: model.localId,
      bCreatedAtMillis: model.createdAt?.millisecondsSinceEpoch,
      bAudioId: model.audioId,
      bPlaylistId: model.playlistId,
    );
  }
}
