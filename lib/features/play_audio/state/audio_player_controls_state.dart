import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../user_preferences/api/user_preferences_store.dart';
import '../model/playback_button_state.dart';
import '../model/playback_progress_state.dart';

part 'audio_player_controls_state.freezed.dart';

@freezed
class AudioPlayerControlsState with _$AudioPlayerControlsState {
  const factory AudioPlayerControlsState({
    required PlaybackButtonState playButtonState,
    required SimpleDataState<bool> isShuffleEnabled,
    required SimpleDataState<bool> isRepeatEnabled,
    PlaybackProgressState? playbackProgress,
    required SimpleDataState<bool> isFirstSong,
    required SimpleDataState<bool> isLastSong,
  }) = _AudioPlayerControlsState;

  factory AudioPlayerControlsState.initial() => AudioPlayerControlsState(
        playButtonState: PlaybackButtonState.idle,
        isShuffleEnabled: SimpleDataState.idle(),
        isRepeatEnabled: SimpleDataState.idle(),
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
    this._userPreferencesStore,
  ) : super(AudioPlayerControlsState.initial()) {
    _init();
  }

  final AudioHandler _audioHandler;
  final UserPreferencesStore _userPreferencesStore;

  final _subscriptions = SubscriptionComposite();

  Future<void> _init() async {
    _subscriptions.add(_audioHandler.playbackState.listen(_onPlaybackStateChanged));
    _subscriptions.add(AudioService.position.listen(_onPositionChanged));
    _subscriptions.add(_audioHandler.mediaItem.listen(_onMediaItemChanged));
    _subscriptions.add(_audioHandler.queue.listen((_) => _updateSkipButtons()));

    _updateSkipButtons();
    _loadInitialPreferences();
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

  Future<void> onShufflePressed() async {
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

    final isSaveShuffleStateEnabled = await _userPreferencesStore.isSaveShuffleStateEnabled();
    if (isSaveShuffleStateEnabled) {
      await _userPreferencesStore.setShuffleEnabled(!beforeShuffleModeEnabled);
    }
  }

  Future<void> onRepeatPressed() async {
    final beforeRepeatModeEnabled = state.isRepeatEnabled.getOrNull;

    if (beforeRepeatModeEnabled == null) {
      Logger.root.warning('Repeat mode is not yet initialized, so not doing anything.');
      return;
    }

    final newRepeatMode = beforeRepeatModeEnabled ? AudioServiceRepeatMode.none : AudioServiceRepeatMode.one;

    _audioHandler.setRepeatMode(newRepeatMode);

    emit(state.copyWith(
      isRepeatEnabled: SimpleDataState.success(!beforeRepeatModeEnabled),
    ));

    final isSaveRepeatStateEnabled = await _userPreferencesStore.isSaveRepeatStateEnabled();
    if (isSaveRepeatStateEnabled) {
      await _userPreferencesStore.setRepeatEnabled(!beforeRepeatModeEnabled);
    }
  }

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
    }

    final playbackProgress = state.playbackProgress ?? PlaybackProgressState.zero();
    final newProgress = playbackProgress.copyWith(buffered: playbackState.bufferedPosition);

    final isShuffleModeEnabled = playbackState.shuffleMode == AudioServiceShuffleMode.all;
    final isRepeatModeEnabled = playbackState.repeatMode == AudioServiceRepeatMode.one;

    emit(state.copyWith(
      playbackProgress: newProgress,
      playButtonState: newPlayButtonState ?? state.playButtonState,
      isShuffleEnabled: SimpleDataState.success(isShuffleModeEnabled),
      isRepeatEnabled: SimpleDataState.success(isRepeatModeEnabled),
    ));
  }

  void _onPositionChanged(Duration position) {
    final playbackProgress = state.playbackProgress ?? PlaybackProgressState.zero();
    final newProgress = playbackProgress.copyWith(current: position);

    emit(state.copyWith(playbackProgress: newProgress));
  }

  Future<void> _onMediaItemChanged(MediaItem? mediaItem) async {
    _updateSkipButtons();

    final playbackProgress = state.playbackProgress ?? PlaybackProgressState.zero();
    final newProgress = playbackProgress.copyWith(
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

  Future<void> _loadInitialPreferences() async {
    final isSaveShuffleStateEnabled = await _userPreferencesStore.isSaveShuffleStateEnabled();

    if (isSaveShuffleStateEnabled) {
      final isShuffleEnabled = await _userPreferencesStore.isShuffleEnabled();

      _audioHandler.setShuffleMode(
        isShuffleEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      );

      emit(state.copyWith(
        isShuffleEnabled: SimpleDataState.success(isShuffleEnabled),
      ));
    }

    final isSaveRepeatStateEnabled = await _userPreferencesStore.isSaveRepeatStateEnabled();
    if (isSaveRepeatStateEnabled) {
      final isRepeatEnabled = await _userPreferencesStore.isRepeatEnabled();

      _audioHandler.setRepeatMode(
        isRepeatEnabled ? AudioServiceRepeatMode.one : AudioServiceRepeatMode.none,
      );

      emit(state.copyWith(
        isRepeatEnabled: SimpleDataState.success(isRepeatEnabled),
      ));
    }
  }
}
