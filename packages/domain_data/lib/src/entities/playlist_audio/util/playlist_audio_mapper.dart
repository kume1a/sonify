import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../model/playlist_audio.dart';

class PlaylistAudioMapper {
  PlaylistAudio dtoToModel(PlaylistAudioDto dto) {
    return PlaylistAudio(
      id: dto.id,
      createdAt: tryMapDate(dto.createdAt),
      audioId: dto.audioId ?? kInvalidId,
      playlistId: dto.playlistId ?? kInvalidId,
    );
  }

  PlaylistAudio entityToModel(PlaylistAudioEntity entity) {
    return PlaylistAudio(
      id: entity.id,
      createdAt: tryMapDateMillis(entity.createdAtMillis),
      audioId: entity.audioId ?? kInvalidId,
      playlistId: entity.playlistId ?? kInvalidId,
    );
  }

  PlaylistAudioEntity modelToEntity(PlaylistAudio model) {
    return PlaylistAudioEntity(
      id: model.id,
      createdAtMillis: model.createdAt?.millisecondsSinceEpoch,
      audioId: model.audioId,
      playlistId: model.playlistId,
      audio: null,
    );
  }

  List<PlaylistAudio> dtoListToModel(List<PlaylistAudioDto> e) {
    return e.map(dtoToModel).toList();
  }
}
