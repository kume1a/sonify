import 'package:common_utilities/common_utilities.dart';

import '../../../shared/constant.dart';
import '../../audio/util/audio_mapper.dart';
import '../model/playlist.dart';
import '../model/playlist_dto.dart';

class PlaylistMapper {
  PlaylistMapper(
    this._audioMapper,
  );

  final AudioMapper _audioMapper;

  Playlist dtoToModel(PlaylistDto dto) {
    return Playlist(
      id: dto.id ?? kInvalidId,
      createdAt: tryMapDate(dto.createdAt),
      name: dto.name ?? '',
      thumbnailPath: dto.thumbnailPath,
      thumbnailUrl: dto.thumbnailUrl,
      spotifyId: dto.spotifyId,
      audios: tryMapList(dto.audios, _audioMapper.dtoToModel),
    );
  }
}
