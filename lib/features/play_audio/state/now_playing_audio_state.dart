import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/util/utils.dart';
import '../../../shared/values/constant.dart';
import '../api/now_playing_audio_info_store.dart';
import '../model/media_item_payload.dart';
import '../model/playback_button_state.dart';
import '../util/enqueue_playlist.dart';
import '../util/like_or_unlike_audio.dart';

part 'now_playing_audio_state.freezed.dart';

@freezed
class NowPlayingAudioState with _$NowPlayingAudioState {
  const factory NowPlayingAudioState({
    String? playlistId,
    required SimpleDataState<Audio> nowPlayingAudio,
    Playlist? nowPlayingPlaylist,
    List<Audio>? nowPlayingAudios,
    required PlaybackButtonState playButtonState,
  }) = _NowPlayingAudioState;

  factory NowPlayingAudioState.initial() => NowPlayingAudioState(
        nowPlayingAudio: SimpleDataState.idle(),
        playButtonState: PlaybackButtonState.idle,
      );
}

extension NowPlayingAudioCubitX on BuildContext {
  NowPlayingAudioCubit get nowPlayingAudioCubit => read<NowPlayingAudioCubit>();
}

@injectable
class NowPlayingAudioCubit extends Cubit<NowPlayingAudioState> {
  NowPlayingAudioCubit(
    this._audioHandler,
    this._playlistRemoteRepository,
    this._audioLocalRepository,
    this._nowPlayingAudioInfoStore,
    this._enqueuePlaylist,
    this._authUserInfoProvider,
    this._likeOrUnlikeAudio,
  ) : super(NowPlayingAudioState.initial()) {
    _init();
  }

  final AudioHandler _audioHandler;
  final PlaylistRemoteRepository _playlistRemoteRepository;
  final AudioLocalRepository _audioLocalRepository;
  final NowPlayingAudioInfoStore _nowPlayingAudioInfoStore;
  final EnqueuePlaylist _enqueuePlaylist;
  final AuthUserInfoProvider _authUserInfoProvider;
  final LikeOrUnlikeAudio _likeOrUnlikeAudio;

  final _subscriptions = SubscriptionComposite();

  Future<void> _init() async {
    _subscriptions.add(_audioHandler.mediaItem.listen(_onMediaItemChanged));
    _subscriptions.add(_audioHandler.playbackState.listen(_onPlaybackStateChanged));
    _subscriptions.add(AudioService.position.listen(_onPositionChanged));
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  Future<void> onLocalAudioPressed(Audio? audio) async {
    if (audio == null) {
      Logger.root.warning('NowPlayingAudioCubit.onLocalAudioPressed: audio is null');
      return;
    }

    if (state.nowPlayingAudio.getOrNull == audio) {
      return;
    }

    final playlistEnqueued = await _ensurePlaylistEnqueued(playlistId: null);
    if (!playlistEnqueued) {
      Logger.root.warning('NowPlayingAudioCubit.onPlaylistAudioPressed: failed to enqueue playlist');
      return;
    }

    if (state.nowPlayingAudios == null) {
      Logger.root.warning('NowPlayingAudioCubit.onPlaylistAudioPressed: nowPlayingAudios is null');
      return;
    }

    final audioIndex = state.nowPlayingAudios?.indexWhere((e) => e.id == audio.id) ?? -1;
    if (audioIndex == -1) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: audioIndex is -1');
      return;
    }

    await _audioHandler.skipToQueueItem(audioIndex);
    _audioHandler.play();
  }

  Future<void> onPlaylistAudioPressed({
    required Audio audio,
    required String playlistId,
  }) async {
    if (state.nowPlayingAudio.getOrNull?.id == audio.id) {
      return;
    }

    final playlistEnqueued = await _ensurePlaylistEnqueued(playlistId: playlistId);
    if (!playlistEnqueued) {
      Logger.root.warning('NowPlayingAudioCubit.onPlaylistAudioPressed: failed to enqueue playlist');
      return;
    }

    if (state.nowPlayingPlaylist == null) {
      Logger.root.warning('NowPlayingAudioCubit.onPlaylistAudioPressed: nowPlayingPlaylist is null');
      return;
    }

    final audioIndex = state.nowPlayingPlaylist!.audios?.indexWhere((e) => e.id == audio.id) ?? -1;
    if (audioIndex == -1) {
      Logger.root.warning('PlaylistCubit.onAudioPressed: audioIndex is -1');
      return;
    }

    await _audioHandler.skipToQueueItem(audioIndex);
    _audioHandler.play();
  }

  Future<void> onPlayPlaylistPressed({
    required String playlistId,
  }) async {
    final playlistEnqueued = await _ensurePlaylistEnqueued(playlistId: playlistId);
    if (!playlistEnqueued) {
      Logger.root.warning('NowPlayingAudioCubit.onPlayPlaylistPressed: failed to enqueue playlist');
      return;
    }

    final beforePlayingAudioInfo = await _nowPlayingAudioInfoStore.getNowPlayingAudioInfo();

    if (beforePlayingAudioInfo == null || beforePlayingAudioInfo.playlistId != playlistId) {
      await _audioHandler.skipToQueueItem(0);
      _audioHandler.play();

      return;
    }

    if (state.playButtonState == PlaybackButtonState.playing) {
      _audioHandler.pause();
    } else {
      _audioHandler.play();
    }
  }

  Future<void> onLikePressed() async {
    final res = await _likeOrUnlikeAudio(
      nowPlayingAudio: state.nowPlayingAudio.getOrNull,
      nowPlayingAudios: state.nowPlayingAudios ?? state.nowPlayingPlaylist?.audios,
    );

    if (res == null) {
      Logger.root.warning('NowPlayingAudioCubit.onLikePressed: failed to like or unlike audio, res is null');
      return;
    }

    emit(state.copyWith(
      nowPlayingAudio: SimpleDataState.success(res.nowPlayingAudio),
      nowPlayingAudios: state.nowPlayingAudios != null ? res.nowPlayingAudios : null,
      nowPlayingPlaylist: state.nowPlayingPlaylist != null
          ? state.nowPlayingPlaylist?.copyWith(audios: res.nowPlayingAudios)
          : null,
    ));
  }

  Future<bool> _ensurePlaylistEnqueued({
    required String? playlistId,
  }) async {
    final nowPlayingAudios = await _loadNowPlayingPlaylist(playlistId: playlistId);
    if (nowPlayingAudios == null || nowPlayingAudios.isEmpty == true) {
      Logger.root.warning('PlaylistCubit._ensurePlaylistEnqueued: playlist.audios empty');
      return false;
    }

    final beforePlayingAudioInfo = await _nowPlayingAudioInfoStore.getNowPlayingAudioInfo();

    if (beforePlayingAudioInfo == null || beforePlayingAudioInfo.playlistId != playlistId) {
      await _enqueuePlaylist(audios: nowPlayingAudios, playlistId: playlistId);
    }

    return true;
  }

  Future<List<Audio>?> _loadNowPlayingPlaylist({
    required String? playlistId,
  }) async {
    if (state.nowPlayingPlaylist != null && state.nowPlayingPlaylist!.id == playlistId) {
      return state.nowPlayingPlaylist?.audios;
    }

    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('PlaylistCubit._loadNowPlayingPlaylist: authUserId is null');
      return null;
    }

    if (playlistId == null) {
      final localUserAudios = await _audioLocalRepository.getAllByUserId(authUserId);
      if (localUserAudios.isErr) {
        Logger.root.warning('PlaylistCubit._loadNowPlayingPlaylist: failed to get local user audios');
        return null;
      }

      final localAudios =
          localUserAudios.dataOrThrow.map((e) => e.audio).where((e) => e != null).cast<Audio>().toList();

      emit(state.copyWith(nowPlayingAudios: localAudios, nowPlayingPlaylist: null));

      return localAudios;
    }

    final playlist = await _playlistRemoteRepository.getPlaylistById(playlistId: playlistId);

    emit(state.copyWith(nowPlayingPlaylist: playlist.rightOrNull, nowPlayingAudios: null));

    return playlist.rightOrNull?.audios;
  }

  Future<void> _onMediaItemChanged(MediaItem? mediaItem) async {
    if (mediaItem?.extras == null) {
      Logger.root.warning('NowPlayingAudioCubit._onMediaItemChanged: mediaItem.extras is null');
      return;
    }

    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('NowPlayingAudioCubit._onMediaItemChanged: authUserId is null');
      return;
    }

    final payload = callOrDefault(
      () => MediaItemPayload.fromExtras(mediaItem?.extras ?? {}),
      null,
    );
    if (payload == null) {
      emit(state.copyWith(nowPlayingAudio: SimpleDataState.failure()));
      return;
    }

    final nowPlayingAudioLike = await _audioLocalRepository.getAudioLikeByUserAndAudioId(
      userId: authUserId,
      audioId: payload.audio.id ?? kInvalidId,
    );

    final nowPlayingAudio = payload.audio.copyWith(audioLike: nowPlayingAudioLike.dataOrNull);

    emit(state.copyWith(
      playlistId: payload.playlistId,
      nowPlayingAudio: SimpleDataState.success(nowPlayingAudio),
    ));

    await _nowPlayingAudioInfoStore.setNowPlayingAudioInfo(
      NowPlayingAudioInfo(
        playlistId: state.nowPlayingPlaylist?.id,
        audioId: payload.audio.id,
        localAudioId: payload.audio.localId,
        position: Duration.zero,
      ),
    );
  }

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
    }
  }

  Future<void> _onPositionChanged(Duration position) async {
    final nowPlayingAudio = await _nowPlayingAudioInfoStore.getNowPlayingAudioInfo();

    if (nowPlayingAudio == null) {
      return;
    }

    await _nowPlayingAudioInfoStore.setNowPlayingAudioInfo(
      NowPlayingAudioInfo(
        playlistId: nowPlayingAudio.playlistId,
        audioId: nowPlayingAudio.audioId,
        localAudioId: nowPlayingAudio.localAudioId,
        position: position,
      ),
    );
  }
}
