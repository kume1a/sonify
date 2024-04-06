import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';
import '../../audio/util/enqueue_audio.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistRepository,
    this._enqueueAudio,
  );

  final PlaylistRepository _playlistRepository;
  final EnqueueAudio _enqueueAudio;

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

  Future<void> onAudioPressed(Audio audio) async {
    await _enqueueAudio.fromAudio(audio);
  }
}
