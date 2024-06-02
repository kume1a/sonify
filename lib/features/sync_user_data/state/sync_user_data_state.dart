import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../entities/playlist/model/event_spotify_playlists_imported.dart';
import '../api/sync_audio_likes.dart';
import '../api/sync_playlist_audios.dart';
import '../api/sync_playlists.dart';
import '../api/sync_user_audio.dart';
import '../api/sync_user_pending_changes.dart';
import '../api/sync_user_playlists.dart';

part 'sync_user_data_state.freezed.dart';

enum SyncAudiosState {
  idle,
  loading,
  loaded,
  nothingToSync,
  error,
}

@freezed
class SyncUserDataState with _$SyncUserDataState {
  const factory SyncUserDataState({
    required SyncAudiosState syncState,
    required int queuedDownloadsCount,
  }) = _SyncUserDataState;

  factory SyncUserDataState.initial() => const SyncUserDataState(
        syncState: SyncAudiosState.idle,
        queuedDownloadsCount: 0,
      );
}

extension SyncUserAudioCubitX on BuildContext {
  SyncUserDataCubit get syncUserAudioCubit => read<SyncUserDataCubit>();
}

@injectable
class SyncUserDataCubit extends Cubit<SyncUserDataState> {
  SyncUserDataCubit(
    this._syncUserAudio,
    this._syncAudioLikes,
    this._pageNavigator,
    this._syncUserPendingChanges,
    this._syncPlaylists,
    this._syncUserPlaylists,
    this._syncPlaylistAudios,
    this._eventBus,
  ) : super(SyncUserDataState.initial()) {
    _init();
  }

  final SyncUserAudio _syncUserAudio;
  final SyncAudioLikes _syncAudioLikes;
  final PageNavigator _pageNavigator;
  final SyncUserPendingChanges _syncUserPendingChanges;
  final SyncPlaylists _syncPlaylists;
  final SyncUserPlaylists _syncUserPlaylists;
  final SyncPlaylistAudios _syncPlaylistAudios;

  final EventBus _eventBus;

  final _subscriptions = SubscriptionComposite();

  Future<void> _init() async {
    _subscriptions.add(_eventBus.on<EventSpotifyPlaylistsImported>().listen((_) => _startSync()));

    return _startSync();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  void onSeeDownloadsPressed() {
    _pageNavigator.toDownloads();
  }

  Future<void> onSyncDataPressed() async {
    if (state.syncState != SyncAudiosState.idle) {
      return;
    }

    return _startSync();
  }

  Future<void> _startSync() async {
    emit(state.copyWith(syncState: SyncAudiosState.loading));

    final syncUserPendingChangesRes = await _syncUserPendingChanges();
    if (syncUserPendingChangesRes.isErr) {
      Logger.root.info('Failed to sync user pending changes, stopping sync process');
      return _handleSyncFailure();
    }

    final syncUserAudioLikesRes = await _syncAudioLikes();
    if (syncUserAudioLikesRes.isErr) {
      Logger.root.info('Failed to sync user audio likes, stopping sync process');
      return _handleSyncFailure();
    }

    final syncPlaylistsRes = await _syncPlaylists();
    if (syncPlaylistsRes.isErr) {
      Logger.root.info('Failed to sync playlists, stopping sync process');
      return _handleSyncFailure();
    }

    final syncUserPlaylistsRes = await _syncUserPlaylists();
    if (syncUserPlaylistsRes.isErr) {
      Logger.root.info('Failed to sync user playlists, stopping sync process');
      return _handleSyncFailure();
    }

    final syncPlaylistAudiosRes = await _syncPlaylistAudios();
    if (syncPlaylistAudiosRes.isErr) {
      Logger.root.info('Failed to sync playlist audios, stopping sync process');
      return _handleSyncFailure();
    }

    final syncUserAudioRes = await _syncUserAudio();

    await syncUserAudioRes.foldAsync(
      () {
        Logger.root.info('Failed to sync user audio, stopping sync process');

        return _handleSyncFailure();
      },
      (r) async {
        if (r.toDownloadCount > 0) {
          emit(state.copyWith(
            syncState: SyncAudiosState.loaded,
            queuedDownloadsCount: r.toDownloadCount,
          ));

          await Future.delayed(const Duration(seconds: 10));

          emit(state.copyWith(
            syncState: SyncAudiosState.idle,
            queuedDownloadsCount: 0,
          ));
        } else {
          emit(state.copyWith(syncState: SyncAudiosState.nothingToSync));

          await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

          emit(state.copyWith(syncState: SyncAudiosState.idle));
        }
      },
    );
  }

  Future<void> _handleSyncFailure() async {
    emit(state.copyWith(syncState: SyncAudiosState.error));

    await Future.delayed(const Duration(seconds: 3));

    emit(state.copyWith(syncState: SyncAudiosState.idle));
  }
}
