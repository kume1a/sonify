import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../../audio/util/audio_mapper.dart';
import '../model/playlist.dart';

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
      audios: tryMapList(dto.audios, _audioMapper.fromDto),
    );
  }
}
