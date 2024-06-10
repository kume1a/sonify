import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/util/audio_extension.dart';
import '../../../shared/util/utils.dart';
import '../model/media_item_payload.dart';

class AppAudioHandler extends BaseAudioHandler {
  AppAudioHandler() {
    _player.playbackEventStream.listen(
      (event) {
        final state = _transformEvent(event);

        playbackState.add(state);
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

    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();

    _player.setAudioSource(_playlist);
  }

  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource).whereNotNull().toList();

    _playlist.addAll(audioSource);

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    if (audioSource == null) {
      return;
    }

    _playlist.add(audioSource);

    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    if (audioSource == null) {
      return;
    }

    _playlist.insert(index, audioSource);

    final newQueue = queue.value..insert(index, mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    _playlist.removeAt(index);

    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    final audioSources = queue.map(_createAudioSource).where((e) => e != null).cast<AudioSource>().toList();

    await _playlist.clear();
    await _playlist.addAll(audioSources);

    final sequence = _player.sequenceState?.effectiveSequence;
    if (sequence == null || sequence.isEmpty) {
      return;
    }
    final items = sequence.map((source) => source.tag as MediaItem);
    this.queue.add(items.toList());
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) {
      return;
    }

    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }

    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

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

      // TODO check this.queue
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  UriAudioSource? _createAudioSource(MediaItem mediaItem) {
    if (mediaItem.extras == null) {
      Logger.root.warning('Media extras is null, mediaItem: $mediaItem');
      return null;
    }

    final payload = callOrDefault(
      () => MediaItemPayload.fromExtras(mediaItem.extras ?? {}),
      null,
    );
    if (payload == null) {
      Logger.root.warning('MediaItemPayload is null, mediaItem: $mediaItem');
      return null;
    }

    final audioUri = payload.audio.audioUri;
    if (audioUri == null) {
      Logger.root.warning('Audio uri is null, audio: ${payload.audio}');
      return null;
    }

    return AudioSource.uri(
      audioUri,
      tag: mediaItem,
    );
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
}
