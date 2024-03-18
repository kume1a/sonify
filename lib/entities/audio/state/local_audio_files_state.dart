import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/audio_player_page.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../api/local_audio_file_repository.dart';
import '../model/local_audio_file.dart';

typedef LocalAudioFilesState = SimpleDataState<List<LocalAudioFile>>;

extension LocalAudioFilesCubitX on BuildContext {
  LocalAudioFilesCubit get localAudioFilesCubit => read<LocalAudioFilesCubit>();
}

@injectable
final class LocalAudioFilesCubit extends EntityLoaderCubit<List<LocalAudioFile>> {
  LocalAudioFilesCubit(
    this._localAudioFileRepository,
    this._pageNavigator,
  ) {
    loadEntityAndEmit();
  }

  final LocalAudioFileRepository _localAudioFileRepository;
  final PageNavigator _pageNavigator;

  @override
  Future<List<LocalAudioFile>?> loadEntity() {
    return _localAudioFileRepository.getAll();
  }

  void onLocalAudioFilePressed(LocalAudioFile localAudioFile) {
    final args = AudioPlayerPageArgs(
      localAudioFileId: localAudioFile.id,
    );

    _pageNavigator.toAudioPlayer(args);
  }
}
