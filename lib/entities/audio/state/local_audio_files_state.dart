import 'package:common_models/common_models.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';
import '../api/local_audio_file_repository.dart';
import '../model/local_audio_file.dart';

typedef LocalAudioFilesState = SimpleDataState<List<LocalAudioFile>>;

@injectable
final class LocalAudioFilesCubit extends EntityLoaderCubit<List<LocalAudioFile>> {
  LocalAudioFilesCubit(
    this._localAudioFileRepository,
  ) {
    loadEntityAndEmit();
  }

  final LocalAudioFileRepository _localAudioFileRepository;

  @override
  Future<List<LocalAudioFile>?> loadEntity() {
    return _localAudioFileRepository.getAll();
  }
}
