import 'package:injectable/injectable.dart';

import '../model/local_music.dart';

@lazySingleton
class LocalMusicMapper {
  LocalMusic songModelToLocalMusic() {
    return LocalMusic(
      id: 0,
      data: '',
      uri: '',
      displayName: '',
      displayNameWOExt: '',
      size: 0,
      album: '',
      artist: '',
      genre: '',
      composer: '',
      dateAdded: 0,
      dateModified: 0,
      duration: 0,
      title: '',
      track: 0,
    );
    // return LocalMusic(
    //   id: songModel.id,
    //   data: songModel.data,
    //   uri: songModel.uri,
    //   displayName: songModel.displayName,
    //   displayNameWOExt: songModel.displayNameWOExt,
    //   size: songModel.size,
    //   album: songModel.album,
    //   artist: songModel.artist,
    //   genre: songModel.genre,
    //   composer: songModel.composer,
    //   dateAdded: songModel.dateAdded,
    //   dateModified: songModel.dateModified,
    //   duration: songModel.duration,
    //   title: songModel.title,
    //   track: songModel.track,
    // );
  }
}
