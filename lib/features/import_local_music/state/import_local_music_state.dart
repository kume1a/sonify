import 'dart:io';

import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';
import 'package:uri_to_file/uri_to_file.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/permission/permission_manager.dart';
import '../../../shared/permission/permission_resolver.dart';
import '../api/query_local_music.dart';
import '../api/query_local_music_artwork.dart';
import '../model/local_music.dart';
import '../model/uploaded_local_music_result.dart';

part 'import_local_music_state.freezed.dart';

enum ImportLocalMusicStage {
  select,
  upload,
  finished,
}

@freezed
class ImportLocalMusicState with _$ImportLocalMusicState {
  const factory ImportLocalMusicState({
    required SimpleDataState<bool> isAudioPermissionGranted,
    required SimpleDataState<List<LocalMusic>> localMusic,
    required List<int> selectedIds,
    required List<LocalMusic> uploadingLocalMusicList,
    required List<UploadedLocalMusicResult> uploadedLocalMusicResults,
    required ImportLocalMusicStage stage,
    required double uploadProgress,
    LocalMusic? uploadingLocalMusic,
  }) = _ImportLocalMusicState;

  factory ImportLocalMusicState.initial() => ImportLocalMusicState(
        isAudioPermissionGranted: SimpleDataState.idle(),
        localMusic: SimpleDataState.idle(),
        selectedIds: [],
        uploadingLocalMusicList: [],
        uploadedLocalMusicResults: [],
        stage: ImportLocalMusicStage.select,
        uploadProgress: 0,
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
    this._audioRemoteRepository,
    this._queryLocalMusicArtwork,
    this._pageNavigator,
  ) : super(ImportLocalMusicState.initial()) {
    _init();
  }

  final QueryLocalMusic _queryLocalMusic;
  final PermissionResolver _permissionResolver;
  final PermissionManager _permissionManager;
  final AudioRemoteRepository _audioRemoteRepository;
  final QueryLocalMusicArtwork _queryLocalMusicArtwork;
  final PageNavigator _pageNavigator;

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

  Future<void> onSubmit() async {
    final localMusic = state.localMusic.getOrNull;
    if (localMusic == null) {
      Logger.root.warning('Local music is null');
      return;
    }

    final selectedLocalMusic = localMusic.where((e) => state.selectedIds.contains(e.id)).toList();

    emit(state.copyWith(
      stage: ImportLocalMusicStage.upload,
      uploadingLocalMusicList: selectedLocalMusic,
    ));

    for (final localMusic in selectedLocalMusic) {
      emit(state.copyWith(uploadingLocalMusic: localMusic));

      if (localMusic.uri == null) {
        _emitUploadLocalMusicResult(UploadedLocalMusicResult(
          localMusic: localMusic,
          failure: const UploadUserLocalMusicFailure.unknown(),
        ));
        continue;
      }

      final audioFile = Platform.isAndroid ? await toFile(localMusic.uri!) : File(localMusic.uri!);
      final audioBytes = await audioFile.readAsBytes();

      final artworkBytes = await _queryLocalMusicArtwork(localMusicId: localMusic.id);

      final result = await _audioRemoteRepository.uploadUserLocalMusic(
        localId: localMusic.id.toString(),
        title: localMusic.title,
        audio: audioBytes,
        author: localMusic.artist,
        durationMs: localMusic.duration,
        thumbnail: artworkBytes,
      );

      _emitUploadLocalMusicResult(UploadedLocalMusicResult(
        localMusic: localMusic,
        failure: result.leftOrNull,
      ));
    }

    if (isClosed) {
      return;
    }

    emit(state.copyWith(
      stage: ImportLocalMusicStage.finished,
      uploadProgress: 1,
      uploadingLocalMusic: null,
    ));
  }

  void onGoBackPressed() {
    _pageNavigator.pop();
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

  void _emitUploadLocalMusicResult(UploadedLocalMusicResult uploadedLocalMusicResult) {
    final uploadedLocalMusicResults = List.of(state.uploadedLocalMusicResults)..add(uploadedLocalMusicResult);

    final uploadingLocalMusic = List.of(state.uploadingLocalMusicList)
        .where((e) => e.id != uploadedLocalMusicResult.localMusic.id)
        .toList();

    final progress = uploadedLocalMusicResults.length /
        (state.uploadingLocalMusicList.length + state.uploadedLocalMusicResults.length);

    if (isClosed) {
      return;
    }

    emit(state.copyWith(
      uploadedLocalMusicResults: uploadedLocalMusicResults,
      uploadingLocalMusicList: uploadingLocalMusic,
      uploadProgress: progress,
    ));
  }
}
