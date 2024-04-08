import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sonify_client/sonify_client.dart';

import '../model/playback_button_state.dart';
import '../model/playback_progress_state.dart';

part 'audio_player_state.freezed.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {
  const factory AudioPlayerState({
    String? playlistName,
    required SimpleDataState<Audio> currentSong,
    required PlaybackButtonState playButtonState,
    PlaybackProgressState? playbackProgress,
  }) = _AudioPldayerState;

  factory AudioPlayerState.initial() => AudioPlayerState(
        currentSong: SimpleDataState.idle(),
        playButtonState: PlaybackButtonState.idle,
      );
}

extension AudioPlayerCubitX on BuildContext {
  AudioPlayerCubit get audioPlayerCubit => read<AudioPlayerCubit>();
}

@injectable
class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit(
    this._audioHandler,
  ) : super(AudioPlayerState.initial()) {
    _init();
  }

  final AudioHandler _audioHandler;

  final _subscriptions = SubscriptionComposite();

  static final panelController = PanelController();

  Future<void> _init() async {
    _subscriptions.add(_audioHandler.playbackState.listen(_onPlaybackStateChanged));
    _subscriptions.add(AudioService.position.listen(_onPositionChanged));
    _subscriptions.add(_audioHandler.mediaItem.listen(_onMediaItemChanged));

    // await _loadPlaylist();

    // _listenToChangesInPlaylist();
    // _listenToCurrentPosition();
    // _listenToBufferedPosition();
    // _listenToTotalDuration();
    // _listenToChangesInSong();
    // _updateSkipButtons();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  void onDownArrowPressed() {
    if (panelController.isAttached) {
      panelController.animatePanelToPosition(
        0.0,
        duration: const Duration(milliseconds: 250),
      );
    }
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
      return;
    }

    _audioHandler.play();
  }

  void onSeek(Duration position) => _audioHandler.seek(position);

  void onSkipToPrevious() => _audioHandler.skipToPrevious();

  void onSkipToNext() => _audioHandler.skipToNext();

  void _onPlaybackStateChanged(PlaybackState playbackState) {
    final isPlaying = playbackState.playing;
    final processingState = playbackState.processingState;

    if (processingState == AudioProcessingState.loading ||
        processingState == AudioProcessingState.buffering) {
      emit(state.copyWith(playButtonState: PlaybackButtonState.loading));
    } else if (!isPlaying) {
      emit(state.copyWith(playButtonState: PlaybackButtonState.paused));
    } else if (processingState != AudioProcessingState.completed) {
      emit(state.copyWith(playButtonState: PlaybackButtonState.playing));
    } else {
      _audioHandler.seek(Duration.zero);
      _audioHandler.pause();
    }

    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      buffered: playbackState.bufferedPosition,
    );

    emit(state.copyWith(playbackProgress: newProgress));
  }

  void _onPositionChanged(Duration position) {
    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      current: position,
    );

    emit(state.copyWith(playbackProgress: newProgress));
  }

  Future<void> _onMediaItemChanged(MediaItem? mediaItem) async {
    Logger.root.info('Media item changed to: $mediaItem');

    final newProgress = (state.playbackProgress ?? PlaybackProgressState.zero()).copyWith(
      total: mediaItem?.duration ?? Duration.zero,
    );

    emit(state.copyWith(
      playbackProgress: newProgress,
      currentSong: SimpleDataState.loading(),
    ));

    final audio = mediaItem?.extras?['audio'] as Audio?;

    if (audio == null) {
      emit(state.copyWith(currentSong: SimpleDataState.failure()));
      return;
    }

    emit(state.copyWith(currentSong: SimpleDataState.success(audio)));

    await _audioHandler.play();
  }

  // Future<void> _loadPlaylist() async {
  // final songRepository = getIt<PlaylistRepository>();
  // final playlist = await songRepository.fetchInitialPlaylist();
  // final mediaItems = playlist
  //     .map((song) => MediaItem(
  //           id: song['id'] ?? '',
  //           album: song['album'] ?? '',
  //           title: song['title'] ?? '',
  //           extras: {'url': song['url']},
  //         ))
  //     .toList();
  // _audioHandler.addQueueItems(mediaItems);
  // }

  // void _listenToChangesInPlaylist() {
  // _audioHandler.queue.listen((playlist) {
  //   if (playlist.isEmpty) {
  //     playlistNotifier.value = [];
  //     currentSongTitleNotifier.value = '';
  //   } else {
  //     final newList = playlist.map((item) => item.title).toList();
  //     playlistNotifier.value = newList;
  //   }
  //   _updateSkipButtons();
  // });
  // }

  // void _listenToChangesInSong() {
  // _audioHandler.mediaItem.listen((mediaItem) {
  //   currentSongTitleNotifier.value = mediaItem?.title ?? '';
  //   _updateSkipButtons();
  // });
  // }

  // void _updateSkipButtons() {
  // final mediaItem = _audioHandler.mediaItem.value;
  // final playlist = _audioHandler.queue.value;
  // if (playlist.length < 2 || mediaItem == null) {
  //   isFirstSongNotifier.value = true;
  //   isLastSongNotifier.value = true;
  // } else {
  //   isFirstSongNotifier.value = playlist.first == mediaItem;
  //   isLastSongNotifier.value = playlist.last == mediaItem;
  // }
  // }

  // void repeat() {
  // repeatButtonNotifier.nextState();
  // final repeatMode = repeatButtonNotifier.value;
  // switch (repeatMode) {
  //   case RepeatState.off:
  //     _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
  //     break;
  //   case RepeatState.repeatSong:
  //     _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
  //     break;
  //   case RepeatState.repeatPlaylist:
  //     _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  //     break;
  // }
  // }

  // void shuffle() {
  // final enable = !isShuffleModeEnabledNotifier.value;
  // isShuffleModeEnabledNotifier.value = enable;
  // if (enable) {
  //   _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
  // } else {
  //   _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
  // }
  // }

  // Future<void> add() async {
  // final songRepository = getIt<PlaylistRepository>();
  // final song = await songRepository.fetchAnotherSong();
  // final mediaItem = MediaItem(
  //   id: song['id'] ?? '',
  //   album: song['album'] ?? '',
  //   title: song['title'] ?? '',
  //   extras: {'url': song['url']},
  // );
  // _audioHandler.addQueueItem(mediaItem);
  // }

  // void remove() {
  // final lastIndex = _audioHandler.queue.value.length - 1;
  // if (lastIndex < 0) return;
  // _audioHandler.removeQueueItemAt(lastIndex);
  // }

  // void dispose() {
  // _audioHandler.customAction('dispose');
  // }

  // void stop() {
  // _audioHandler.stop();
  // }
// }
}
