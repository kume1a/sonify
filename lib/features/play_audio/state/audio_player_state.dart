import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../entities/audio/api/local_audio_file_repository.dart';

part 'audio_player_state.freezed.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {
  const factory AudioPlayerState({
    String? playlistName,
  }) = _AudioPlayerState;

  factory AudioPlayerState.initial() => const AudioPlayerState();
}

@injectable
class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit(
    this._localAudioFileRepository,
    this._audioHandler,
  ) : super(AudioPlayerState.initial());

  final LocalAudioFileRepository _localAudioFileRepository;
  final AudioHandler _audioHandler;

  int? _localAudioFileId;

  Future<void> init(int localAudioFileId) async {
    _localAudioFileId = localAudioFileId;

    _queueAudioFile();

    await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    _updateSkipButtons();
  }

  Future<void> _queueAudioFile() async {
    if (_localAudioFileId == null) {
      Logger.root.warning('Local audio file id is null');
      return;
    }

    final localAudioFile = await _localAudioFileRepository.getById(_localAudioFileId!);

    if (localAudioFile == null) {
      return;
    }

    final mediaItem = MediaItem(
      id: localAudioFile.id.toString(),
      title: localAudioFile.title,
      artist: localAudioFile.author,
      // duration: Duration(milliseconds: localAudioFile.),
      artUri: localAudioFile.thumbnailPath != null ? Uri.parse(localAudioFile.thumbnailPath!) : null,
      extras: {
        'localPath': localAudioFile.path,
      },
    );

    await _audioHandler.addQueueItem(mediaItem);
  }

  Future<void> _loadPlaylist() async {
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
  }

  void _listenToChangesInPlaylist() {
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
  }

  void _listenToPlaybackState() {
    // _audioHandler.playbackState.listen((playbackState) {
    //   final isPlaying = playbackState.playing;
    //   final processingState = playbackState.processingState;
    //   if (processingState == AudioProcessingState.loading ||
    //       processingState == AudioProcessingState.buffering) {
    //     playButtonNotifier.value = ButtonState.loading;
    //   } else if (!isPlaying) {
    //     playButtonNotifier.value = ButtonState.paused;
    //   } else if (processingState != AudioProcessingState.completed) {
    //     playButtonNotifier.value = ButtonState.playing;
    //   } else {
    //     _audioHandler.seek(Duration.zero);
    //     _audioHandler.pause();
    //   }
    // });
  }

  void _listenToCurrentPosition() {
    // AudioService.position.listen((position) {
    //   final oldState = progressNotifier.value;
    //   progressNotifier.value = ProgressBarState(
    //     current: position,
    //     buffered: oldState.buffered,
    //     total: oldState.total,
    //   );
    // });
  }

  void _listenToBufferedPosition() {
    // _audioHandler.playbackState.listen((playbackState) {
    //   final oldState = progressNotifier.value;
    //   progressNotifier.value = ProgressBarState(
    //     current: oldState.current,
    //     buffered: playbackState.bufferedPosition,
    //     total: oldState.total,
    //   );
    // });
  }

  void _listenToTotalDuration() {
    // _audioHandler.mediaItem.listen((mediaItem) {
    //   final oldState = progressNotifier.value;
    //   progressNotifier.value = ProgressBarState(
    //     current: oldState.current,
    //     buffered: oldState.buffered,
    //     total: mediaItem?.duration ?? Duration.zero,
    //   );
    // });
  }

  void _listenToChangesInSong() {
    // _audioHandler.mediaItem.listen((mediaItem) {
    //   currentSongTitleNotifier.value = mediaItem?.title ?? '';
    //   _updateSkipButtons();
    // });
  }

  void _updateSkipButtons() {
    // final mediaItem = _audioHandler.mediaItem.value;
    // final playlist = _audioHandler.queue.value;
    // if (playlist.length < 2 || mediaItem == null) {
    //   isFirstSongNotifier.value = true;
    //   isLastSongNotifier.value = true;
    // } else {
    //   isFirstSongNotifier.value = playlist.first == mediaItem;
    //   isLastSongNotifier.value = playlist.last == mediaItem;
    // }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
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
  }

  void shuffle() {
    // final enable = !isShuffleModeEnabledNotifier.value;
    // isShuffleModeEnabledNotifier.value = enable;
    // if (enable) {
    //   _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    // } else {
    //   _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    // }
  }

  Future<void> add() async {
    // final songRepository = getIt<PlaylistRepository>();
    // final song = await songRepository.fetchAnotherSong();
    // final mediaItem = MediaItem(
    //   id: song['id'] ?? '',
    //   album: song['album'] ?? '',
    //   title: song['title'] ?? '',
    //   extras: {'url': song['url']},
    // );
    // _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    // final lastIndex = _audioHandler.queue.value.length - 1;
    // if (lastIndex < 0) return;
    // _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    // _audioHandler.customAction('dispose');
  }

  void stop() {
    // _audioHandler.stop();
  }
}
