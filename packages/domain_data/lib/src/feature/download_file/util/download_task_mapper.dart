import 'package:common_utilities/common_utilities.dart';

import '../../../entities/playlist_audio/model/playlist_audio.dart';
import '../../../entities/user_audio/model/user_audio.dart';
import '../../../shared/assemble_resource_url.dart';
import '../../../shared/resource_save_path_provider.dart';
import '../../../shared/uuid_factory.dart';
import '../model/download_task.dart';
import '../model/file_type.dart';

class DownloadTaskMapper {
  DownloadTaskMapper(
    this._uuidFactory,
  );

  final UuidFactory _uuidFactory;

  Future<DownloadTask?> userAudioToDownloadTask(UserAudio userAudio) async {
    final uri = tryMap(userAudio.audio?.path, (path) => Uri.tryParse(assembleRemoteMediaUrl(path)));
    if (uri == null) {
      return null;
    }

    const fileType = FileType.audioMp3;

    final savePath = await _getSavePath(fileType);

    return DownloadTask.initial(
      id: _uuidFactory.generate(),
      savePath: savePath,
      uri: uri,
      fileType: fileType,
      payload: DownloadTaskPayload(
        userAudio: userAudio,
      ),
    );
  }

  Future<DownloadTask?> playlistAudioToDownloadTask(PlaylistAudio playlistAudio) async {
    final uri = tryMap(playlistAudio.audio?.path, (path) => Uri.tryParse(assembleRemoteMediaUrl(path)));
    if (uri == null) {
      return null;
    }

    const fileType = FileType.audioMp3;

    final savePath = await _getSavePath(fileType);

    return DownloadTask.initial(
      id: _uuidFactory.generate(),
      savePath: savePath,
      uri: uri,
      fileType: fileType,
      payload: DownloadTaskPayload(
        playlistAudio: playlistAudio,
      ),
    );
  }

  Future<String> _getSavePath(FileType fileType) async {
    switch (fileType) {
      case FileType.audioMp3:
        final dirPath = await ResourceSavePathProvider.getAudioMp3SavePath();
        final fileName = _uuidFactory.generate();

        return '$dirPath/$fileName.mp3';
    }
  }
}
