import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/play_audio/api/now_playing_audio_info_store.dart';
import '../../../features/play_audio/util/enqueue_playlist.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistRemoteRepository,
    this._enqueuePlaylist,
    this._nowPlayingAudioInfoStore,
    this._audioHandler,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final EnqueuePlaylist _enqueuePlaylist;
  final NowPlayingAudioInfoStore _nowPlayingAudioInfoStore;
  final AudioHandler _audioHandler;

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

    final res = await _playlistRemoteRepository.getPlaylistById(
      playlistId: _playlistId!,
    );

    return res.rightOrNull;
  }

  Future<void> onAudioPressed(Audio audio) async {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: _playlistId is null');
      return;
    }

    final playlist = state.getOrNull;

    if (playlist == null || playlist.audios == null || playlist.audios?.isEmpty == true) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: playlist is null or audios is empty/null');
      return;
    }

    final beforePlayingAudioInfo = await _nowPlayingAudioInfoStore.getNowPlayingAudioInfo();

    if (beforePlayingAudioInfo == null || beforePlayingAudioInfo.playlistId != _playlistId) {
      await _enqueuePlaylist(playlist.audios!);
    }

    final audioIndex = playlist.audios!.indexWhere((e) => e.id == audio.id);
    if (audioIndex == -1) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: audioIndex is -1');
      return;
    }

    await _audioHandler.skipToQueueItem(audioIndex);
    await _audioHandler.play();

    await _nowPlayingAudioInfoStore.setNowPlayingAudioInfo(
      NowPlayingAudioInfo(
        playlistId: _playlistId!,
        audioId: audio.id,
        localAudioId: null,
        position: Duration.zero,
      ),
    );
  }
}
