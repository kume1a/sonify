import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/play_audio/api/now_playing_audio_info_store.dart';
import '../../../features/play_audio/util/enqueue_playlist.dart';

part 'playlist_state.freezed.dart';

@freezed
class PlaylistState with _$PlaylistState {
  const factory PlaylistState({
    required SimpleDataState<Playlist> playlist,
    Audio? nowPlayingAudio,
    required bool isPlaylistPlaying,
  }) = _PlaylistState;

  factory PlaylistState.initial() => PlaylistState(
        playlist: SimpleDataState.idle(),
        isPlaylistPlaying: false,
      );
}

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit(
    this._playlistRemoteRepository,
    this._enqueuePlaylist,
    this._nowPlayingAudioInfoStore,
    this._audioHandler,
  ) : super(PlaylistState.initial());

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final EnqueuePlaylist _enqueuePlaylist;
  final NowPlayingAudioInfoStore _nowPlayingAudioInfoStore;
  final AudioHandler _audioHandler;

  String? _playlistId;

  void init(String playlistId) {
    _playlistId = playlistId;

    loadEntityAndEmit();
  }

  Future<void> loadEntityAndEmit() async {
    final previousData = state.playlist.getOrNull;

    emit(state.copyWith(playlist: SimpleDataState.loading()));

    final optionalEntity = await loadEntity();

    if (isClosed) {
      return;
    }

    if (optionalEntity == null) {
      emit(state.copyWith(playlist: SimpleDataState.failure(previousData)));
      return;
    }

    emit(state.copyWith(playlist: SimpleDataState.success(optionalEntity)));
  }

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
    if (state.nowPlayingAudio == audio) {
      return;
    }

    await _ensurePlaylistEnqueued();

    final audioIndex = state.playlist.getOrNull?.audios?.indexWhere((e) => e.id == audio.id) ?? -1;
    if (audioIndex == -1) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: audioIndex is -1');
      return;
    }

    await _audioHandler.skipToQueueItem(audioIndex);
    _audioHandler.play();

    await _nowPlayingAudioInfoStore.setNowPlayingAudioInfo(
      NowPlayingAudioInfo(
        playlistId: _playlistId!,
        audioId: audio.id,
        localAudioId: null,
        position: Duration.zero,
      ),
    );

    emit(state.copyWith(
      nowPlayingAudio: audio,
      isPlaylistPlaying: true,
    ));
  }

  Future<void> onPlayPlaylistPressed() async {
    await _ensurePlaylistEnqueued();

    if (state.isPlaylistPlaying) {
      _audioHandler.pause();
      emit(state.copyWith(isPlaylistPlaying: false));
      return;
    }

    if (state.nowPlayingAudio != null) {
      _audioHandler.play();
      emit(state.copyWith(isPlaylistPlaying: true));
      return;
    }

    // not playing and no nowPlayingAudio, play the first audio

    final firstAudio = state.playlist.getOrNull?.audios?.firstOrNull;
    if (firstAudio == null) {
      Logger.root.info('PlaylistCubit.onPlayPlaylistPressed: firstAudio is null');
      return;
    }

    await _audioHandler.skipToQueueItem(0);
    _audioHandler.play();

    await _nowPlayingAudioInfoStore.setNowPlayingAudioInfo(
      NowPlayingAudioInfo(
        playlistId: _playlistId!,
        audioId: firstAudio.id,
        localAudioId: null,
        position: Duration.zero,
      ),
    );

    emit(state.copyWith(
      nowPlayingAudio: firstAudio,
      isPlaylistPlaying: true,
    ));
  }

  Future<void> _ensurePlaylistEnqueued() async {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: _playlistId is null');
      return;
    }

    final playlist = state.playlist.getOrNull;

    if (playlist == null || playlist.audios == null || playlist.audios?.isEmpty == true) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: playlist is null or audios is empty/null');
      return;
    }

    final beforePlayingAudioInfo = await _nowPlayingAudioInfoStore.getNowPlayingAudioInfo();

    if (beforePlayingAudioInfo == null || beforePlayingAudioInfo.playlistId != _playlistId) {
      await _enqueuePlaylist(playlist.audios!);
    }
  }
}
