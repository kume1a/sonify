import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../api/sync_user_audio.dart';

part 'sync_user_audio_state.freezed.dart';

enum SyncAudiosState {
  idle,
  loading,
  loaded,
  nothingToSync,
  error,
}

@freezed
class SyncUserAudioState with _$SyncUserAudioState {
  const factory SyncUserAudioState({
    required SyncAudiosState syncState,
    required int queuedDownloadsCount,
    SyncUserAudioError? error,
  }) = _SyncUserAudioState;

  factory SyncUserAudioState.initial() => const SyncUserAudioState(
        syncState: SyncAudiosState.idle,
        queuedDownloadsCount: 0,
      );
}

extension SyncUserAudioCubitX on BuildContext {
  SyncUserAudioCubit get syncUserAudioCubit => read<SyncUserAudioCubit>();
}

@injectable
class SyncUserAudioCubit extends Cubit<SyncUserAudioState> {
  SyncUserAudioCubit(
    this._syncUserAudio,
    this._pageNavigator,
  ) : super(SyncUserAudioState.initial()) {
    _init();
  }

  final SyncUserAudio _syncUserAudio;
  final PageNavigator _pageNavigator;

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

    await _syncUserAudio().awaitFold(
      (l) async {
        emit(state.copyWith(
          syncState: SyncAudiosState.error,
          error: l,
        ));

        await Future.delayed(const Duration(seconds: 3));

        emit(state.copyWith(syncState: SyncAudiosState.idle));
      },
      (r) async {
        if (r.queuedDownloadsCount > 0) {
          emit(state.copyWith(
            syncState: SyncAudiosState.loaded,
            queuedDownloadsCount: r.queuedDownloadsCount,
          ));

          await Future.delayed(const Duration(seconds: 10));

          emit(state.copyWith(
            syncState: SyncAudiosState.idle,
            queuedDownloadsCount: 0,
          ));
        } else {
          emit(state.copyWith(syncState: SyncAudiosState.nothingToSync));

          await Future.delayed(const Duration(seconds: 3));

          emit(state.copyWith(syncState: SyncAudiosState.idle));
        }
      },
    );
  }
}
