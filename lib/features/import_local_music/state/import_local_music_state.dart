import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/permission/permission_manager.dart';
import '../../../shared/permission/permission_resolver.dart';
import '../api/query_local_music.dart';
import '../model/local_music.dart';

part 'import_local_music_state.freezed.dart';

@freezed
class ImportLocalMusicState with _$ImportLocalMusicState {
  const factory ImportLocalMusicState({
    required SimpleDataState<bool> isAudioPermissionGranted,
    required SimpleDataState<List<LocalMusic>> localMusic,
    required List<int> selectedIds,
  }) = _ImportLocalMusicState;

  factory ImportLocalMusicState.initial() => ImportLocalMusicState(
        isAudioPermissionGranted: SimpleDataState.idle(),
        localMusic: SimpleDataState.idle(),
        selectedIds: [],
      );
}

extension ImportLocalMusicCubitX on BuildContext {
  ImportLocalMusicCubit get importLocalMusicCubit => read<ImportLocalMusicCubit>();
}

@injectable
class ImportLocalMusicCubit extends Cubit<ImportLocalMusicState> {
  ImportLocalMusicCubit(
    this._queryLocalMusic,
    this._permissionResolver,
    this._permissionManager,
  ) : super(ImportLocalMusicState.initial()) {
    _init();
  }

  final QueryLocalMusic _queryLocalMusic;
  final PermissionResolver _permissionResolver;
  final PermissionManager _permissionManager;

  Future<void> _init() async {
    emit(state.copyWith(isAudioPermissionGranted: SimpleDataState.loading()));
    final isAudioPermissionGranted = await _permissionManager.isAudioGranted();
    emit(state.copyWith(isAudioPermissionGranted: SimpleDataState.success(isAudioPermissionGranted)));

    final isAudioPermissionResolved = await _permissionResolver.resolveAudioPermission();
    if (!isAudioPermissionResolved) {
      return;
    }

    _importLocalMusic();
  }

  Future<void> onGrantAudioPermissionPressed() async {
    emit(state.copyWith(isAudioPermissionGranted: SimpleDataState.loading()));
    final isAudioPermissionResolved = await _permissionResolver.resolveAudioPermission();
    emit(state.copyWith(isAudioPermissionGranted: SimpleDataState.success(isAudioPermissionResolved)));

    if (isAudioPermissionResolved) {
      _importLocalMusic();
    }
  }

  Future<void> onMusicSelectToggled(LocalMusic localMusic) async {
    final selectedIds = List.of(state.selectedIds);

    if (selectedIds.contains(localMusic.id)) {
      selectedIds.remove(localMusic.id);
    } else {
      selectedIds.add(localMusic.id);
    }

    emit(state.copyWith(selectedIds: selectedIds));
  }

  Future<void> _importLocalMusic() async {
    emit(state.copyWith(localMusic: SimpleDataState.loading()));

    final localMusic = await _queryLocalMusic();

    final selectedIds = localMusic.fold(
      (_) => <int>[],
      (r) => r.map((e) => e.id).toList(),
    );

    emit(state.copyWith(
      localMusic: SimpleDataState.fromEither(localMusic),
      selectedIds: selectedIds,
    ));
  }
}
