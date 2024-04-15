import 'package:injectable/injectable.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../model/local_music.dart';

@lazySingleton
class LocalMusicMapper {
  LocalMusic songModelToLocalMusic(SongModel songModel) {
    return LocalMusic(
      id: songModel.id,
      data: songModel.data,
      uri: songModel.uri,
      displayName: songModel.displayName,
      displayNameWOExt: songModel.displayNameWOExt,
      size: songModel.size,
      album: songModel.album,
      artist: songModel.artist,
      genre: songModel.genre,
      composer: songModel.composer,
      dateAdded: songModel.dateAdded,
      dateModified: songModel.dateModified,
      duration: songModel.duration,
      title: songModel.title,
      track: songModel.track,
    );
  }
}
