import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../api/sync_user_audio.dart';
import '../api/sync_user_audio_likes.dart';
import '../api/sync_user_pending_changes.dart';

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
    this._syncUserAudioLikes,
    this._pageNavigator,
    this._syncUserPendingChanges,
  ) : super(SyncUserDataState.initial()) {
    _init();
  }

  final SyncUserAudio _syncUserAudio;
  final SyncUserAudioLikes _syncUserAudioLikes;
  final PageNavigator _pageNavigator;
  final SyncUserPendingChanges _syncUserPendingChanges;

  Future<void> _init() async {
    return _startSync();
  }

  void onSeeDownloadsPressed() {
    _pageNavigator.toDownloads();
  }

  Future<void> onSyncAudioFilesPressed() async {
    if (state.syncState != SyncAudiosState.idle) {
      return;
    }

    return _startSync();
  }

  Future<void> _startSync() async {
    emit(state.copyWith(syncState: SyncAudiosState.loading));

    await Future.delayed(const Duration(seconds: 1));

    final syncUserPendingChangesRes = await _syncUserPendingChanges();
    if (syncUserPendingChangesRes.isErr) {
      return _handleSyncFailure();
    }

    final syncUserAudioLikesRes = await _syncUserAudioLikes();
    if (syncUserAudioLikesRes.isErr) {
      return _handleSyncFailure();
    }

    final syncUserAudioRes = await _syncUserAudio();

    await syncUserAudioRes.foldAsync(
      () => _handleSyncFailure(),
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
