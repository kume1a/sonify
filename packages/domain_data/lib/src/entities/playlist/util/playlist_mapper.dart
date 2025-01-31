import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../../shared/constant.dart';
import '../../playlist_audio/util/playlist_audio_mapper.dart';
import '../model/playlist.dart';
import 'process_status_mapper.dart';

class PlaylistMapper {
  PlaylistMapper(
    this._playlistAudioMapper,
    this._processStateMapper,
  );

  final PlaylistAudioMapper _playlistAudioMapper;
  final ProcessStatusMapper _processStateMapper;

  Playlist dtoToModel(PlaylistDto dto) {
    return Playlist(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      name: dto.name ?? '',
      thumbnailPath: dto.thumbnailPath,
      thumbnailUrl: dto.thumbnailUrl,
      spotifyId: dto.spotifyId,
      audioImportStatus: _processStateMapper.schemaToEnum(dto.audioImportStatus),
      audioCount: dto.audioCount ?? 0,
      totalAudioCount: dto.totalAudioCount ?? 0,
      playlistAudios: tryMapList(dto.playlistAudios, _playlistAudioMapper.dtoToModel),
    );
  }

  PlaylistEntity modelToEntity(Playlist playlist) {
    return PlaylistEntity(
      id: playlist.id,
      createdAtMillis: playlist.createdAt?.millisecondsSinceEpoch,
      name: playlist.name,
      thumbnailPath: playlist.thumbnailPath,
      thumbnailUrl: playlist.thumbnailUrl,
      spotifyId: playlist.spotifyId,
      audioCount: playlist.audioCount,
      totalAudioCount: playlist.totalAudioCount,
      audioImportStatus: _processStateMapper.enumToSchema(playlist.audioImportStatus),
    );
  }

  Playlist entityToModel(
    PlaylistEntity e, {
    List<PlaylistAudioEntity>? playlistAudioEntities,
  }) {
    final playlistAudios = playlistAudioEntities
        ?.map((e) => e.audio != null ? _playlistAudioMapper.entityToModel(e) : null)
        .nonNulls
        .toList();

    return Playlist(
      id: e.id ?? kInvalidId,
      createdAt: tryMapDateMillis(e.createdAtMillis),
      name: e.name ?? '',
      thumbnailPath: e.thumbnailPath,
      thumbnailUrl: e.thumbnailUrl,
      spotifyId: e.spotifyId,
      audioImportStatus: _processStateMapper.schemaToEnum(e.audioImportStatus),
      audioCount: e.audioCount ?? 0,
      totalAudioCount: e.totalAudioCount ?? 0,
      playlistAudios: playlistAudios,
    );
  }
}
