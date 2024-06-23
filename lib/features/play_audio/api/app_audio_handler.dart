import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import '../util/mediaItemToAudioSource.dart';

class AppAudioHandler extends BaseAudioHandler {
  AppAudioHandler() {
    _listenForPlaybackStateChanges();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();

    _player.setAudioSource(_playlist);
  }

  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) {
    final audioSource = mediaItems.map(mediaItemToAudioSource).whereNotNull().toList();

    _playlist.addAll(audioSource);

    return Future.value();
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) {
    final audioSource = mediaItemToAudioSource(mediaItem);
    if (audioSource == null) {
      return Future.value();
    }

    _playlist.add(audioSource);

    return Future.value();
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) {
    final audioSource = mediaItemToAudioSource(mediaItem);
    if (audioSource == null) {
      return Future.value();
    }

    _playlist.insert(index, audioSource);

    return Future.value();
  }

  @override
  Future<void> removeQueueItemAt(int index) {
    _playlist.removeAt(index);

    return Future.value();
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    final audioSources =
        queue.map(mediaItemToAudioSource).where((e) => e != null).cast<AudioSource>().toList();

    await _playlist.clear();
    await _playlist.addAll(audioSources);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) {
    return _player.setSpeed(speed);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) {
      return;
    }

    Logger.root.info(
        'AudioHandler skipToQueueItem: $index, shuffleModeEnabled: ${_player.shuffleModeEnabled}, shuffleIndices: ${_player.shuffleIndices}');

    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() {
    if (_player.effectiveIndices != null && _player.effectiveIndices!.isNotEmpty) {
      final isLast = _player.effectiveIndices?.lastOrNull == _player.currentIndex;

      if (isLast) {
        return _player.seek(
          Duration.zero,
          index: _player.effectiveIndices!.firstOrNull ?? 0,
        );
      }
    }

    return _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() {
    if (_player.effectiveIndices != null && _player.effectiveIndices!.isNotEmpty) {
      final isFirst = _player.effectiveIndices?.firstOrNull == _player.currentIndex;

      if (isFirst) {
        return _player.seek(
          Duration.zero,
          index: _player.effectiveIndices!.lastOrNull ?? 0,
        );
      }
    }

    return _player.seekToPrevious();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  void _listenForPlaybackStateChanges() {
    _player.playbackEventStream.listen(
      (event) {
        final state = _transformEvent(event);

        playbackState.add(state);

        final effectiveIndices = _player.effectiveIndices;

        if (effectiveIndices != null && effectiveIndices.isNotEmpty) {
          final isLast = effectiveIndices.lastOrNull == event.currentIndex;

          if (isLast && event.processingState == ProcessingState.completed) {
            final firstIndex = effectiveIndices.firstOrNull ?? 0;

            Logger.root.finer('Playback completed, seeking to the beginning of the next song, $firstIndex');

            Future.delayed(Duration.zero, () => _player.seek(Duration.zero, index: firstIndex));
          }
        }
      },
      onError: (Object error) {
        Logger.root.warning('Playback error: $error');

        _player.stop();

        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          errorCode: -1,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) {
        return;
      }
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) {
        return;
      }
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) {
        return;
      }

      final sequence = sequenceState.effectiveSequence;
      if (sequence.isEmpty) {
        return;
      }
      final items = sequence.map((source) => source.tag as MediaItem);

      queue.add(items.toList());
    });
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToPrevious,
        MediaAction.skipToNext,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      repeatMode: const {
        LoopMode.off: AudioServiceRepeatMode.none,
        LoopMode.one: AudioServiceRepeatMode.one,
        LoopMode.all: AudioServiceRepeatMode.all,
      }[_player.loopMode]!,
    );
  }
}
