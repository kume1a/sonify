import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../model/playback_button_state.dart';
import '../model/playback_progress_state.dart';

part 'audio_player_controls_state.freezed.dart';

@freezed
class AudioPlayerControlsState with _$AudioPlayerControlsState {
  const factory AudioPlayerControlsState({
    required PlaybackButtonState playButtonState,
    required SimpleDataState<bool> isShuffleEnabled,
    PlaybackProgressState? playbackProgress,
    required SimpleDataState<bool> isFirstSong,
    required SimpleDataState<bool> isLastSong,
  }) = _AudioPlayerControlsState;

  factory AudioPlayerControlsState.initial() => AudioPlayerControlsState(
        playButtonState: PlaybackButtonState.idle,
        isShuffleEnabled: SimpleDataState.idle(),
        isFirstSong: SimpleDataState.idle(),
        isLastSong: SimpleDataState.idle(),
      );
}

extension AudioPlayerControlsCubitX on BuildContext {
  AudioPlayerControlsCubit get audioPlayerControlsCubit => read<AudioPlayerControlsCubit>();
}

@injectable
class AudioPlayerControlsCubit extends Cubit<AudioPlayerControlsState> {
  AudioPlayerControlsCubit(
    this._audioHandler,
  ) : super(AudioPlayerControlsState.initial()) {
    _init();
  }

  final AudioHandler _audioHandler;

  final _subscriptions = SubscriptionComposite();

  Future<void> _init() async {
    _subscriptions.add(_audioHandler.playbackState.listen(_onPlaybackStateChanged));
    _subscriptions.add(AudioService.position.listen(_onPositionChanged));
    _subscriptions.add(_audioHandler.mediaItem.listen(_onMediaItemChanged));
    _subscriptions.add(_audioHandler.queue.listen((_) => _updateSkipButtons()));

    _updateSkipButtons();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  void onPlayOrPause() {
    if (state.playButtonState == PlaybackButtonState.idle ||
        state.playButtonState == PlaybackButtonState.loading) {
      Logger.root.warning(
          'Play button state is ${state.playButtonState}, so not doing anything on play or pause button click.');
      return;
    }

    if (state.playButtonState == PlaybackButtonState.playing) {
      _audioHandler.pause();
    } else {
      _audioHandler.play();
    }
  }

  void onSeek(Duration position) => _audioHandler.seek(position);

  void onSkipToPrevious() => _audioHandler.skipToPrevious();

  void onSkipToNext() => _audioHandler.skipToNext();

  void _onPlaybackStateChanged(PlaybackState playbackState) {
    final isPlaying = playbackState.playing;
    final processingState = playbackState.processingState;

    PlaybackButtonState? newPlayButtonState;
    if (processingState == AudioProcessingState.loading ||
        processingState == AudioProcessingState.buffering) {
      newPlayButtonState = PlaybackButtonState.loading;
    } else if (!isPlaying) {
      newPlayButtonState = PlaybackButtonState.paused;
    } else if (processingState != AudioProcessingState.completed) {
      newPlayButtonState = PlaybackButtonState.playing;
    } else {
      _audioHandler.seek(Duration.zero);
      _audioHandler.pause();
    }

    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      buffered: playbackState.bufferedPosition,
    );

    final isShuffleModeEnabled = playbackState.shuffleMode == AudioServiceShuffleMode.all;

    emit(state.copyWith(
      playbackProgress: newProgress,
      playButtonState: newPlayButtonState ?? state.playButtonState,
      isShuffleEnabled: SimpleDataState.success(isShuffleModeEnabled),
    ));
  }

  void _onPositionChanged(Duration position) {
    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      current: position,
    );

    emit(state.copyWith(playbackProgress: newProgress));
  }

  Future<void> _onMediaItemChanged(MediaItem? mediaItem) async {
    _updateSkipButtons();

    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      total: mediaItem?.duration ?? Duration.zero,
    );

    emit(state.copyWith(playbackProgress: newProgress));
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;

    if (playlist.length < 2 || mediaItem == null) {
      emit(state.copyWith(
        isFirstSong: SimpleDataState.success(true),
        isLastSong: SimpleDataState.success(true),
      ));
    } else {
      emit(state.copyWith(
        isFirstSong: SimpleDataState.success(playlist.first == mediaItem),
        isLastSong: SimpleDataState.success(playlist.last == mediaItem),
      ));
    }
  }

  void onShufflePressed() {
    final beforeShuffleModeEnabled = state.isShuffleEnabled.getOrNull;

    if (beforeShuffleModeEnabled == null) {
      Logger.root.warning('Shuffle mode is not yet initialized, so not doing anything.');
      return;
    }

    final newShuffleMode =
        beforeShuffleModeEnabled ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all;

    _audioHandler.setShuffleMode(newShuffleMode);

    emit(state.copyWith(
      isShuffleEnabled: SimpleDataState.success(!beforeShuffleModeEnabled),
    ));
  }
}
