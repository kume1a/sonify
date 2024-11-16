import 'package:collection/collection.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/connectivity_status.dart';
import '../../../shared/util/utils.dart';

@lazySingleton
class FilterPlayableAudios {
  FilterPlayableAudios(
    this._connectivityStatus,
  );

  final ConnectivityStatus _connectivityStatus;

  Future<List<Audio>?> playlistAudios(Playlist? playlist) {
    if (playlist == null) {
      return Future.value();
    }

    final audios = playlist.playlistAudios?.map((e) => e.audio).whereNotNull();

    return _filterPlayableAudios(audios);
  }

  Future<List<Audio>?> _filterPlayableAudios(Iterable<Audio>? audios) async {
    if (audios == null) {
      return null;
    }

    final canPlayRemoteAudios = await _connectivityStatus.checkConnection();

    return audios.where((e) => canPlayRemoteAudios || e.localPath.notNullOrEmpty).toList();
  }
}
