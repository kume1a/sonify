import 'package:common_models/common_models.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistRepository,
  );

  final PlaylistRepository _playlistRepository;

  String? _playlistId;

  void init(String playlistId) {
    _playlistId = playlistId;

    loadEntityAndEmit();
  }

  @override
  Future<Playlist?> loadEntity() async {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.loadEntity: _playlistId is null');
      return null;
    }

    final res = await _playlistRepository.getPlaylistById(
      playlistId: _playlistId!,
    );

    return res.rightOrNull;
  }
}
