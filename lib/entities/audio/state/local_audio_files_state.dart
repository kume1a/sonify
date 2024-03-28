import 'package:audio_service/audio_service.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/auth/api/auth_user_info_provider.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../api/local_audio_file_repository.dart';
import '../model/event_local_audio_file.dart';
import '../model/local_audio_file.dart';

typedef LocalAudioFilesState = SimpleDataState<List<LocalAudioFile>>;

extension LocalAudioFilesCubitX on BuildContext {
  LocalAudioFilesCubit get localAudioFilesCubit => read<LocalAudioFilesCubit>();
}

@injectable
final class LocalAudioFilesCubit extends EntityLoaderCubit<List<LocalAudioFile>> {
  LocalAudioFilesCubit(
    this._localAudioFileRepository,
    this._authUserInfoProvider,
    this._eventBus,
    this._audioHandler,
  ) {
    _init();

    loadEntityAndEmit();
  }

  final LocalAudioFileRepository _localAudioFileRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final EventBus _eventBus;
  final AudioHandler _audioHandler;

  final _subscriptions = SubscriptionComposite();

  void _init() {
    _subscriptions.add(
      _eventBus.on<EventLocalAudioFile>().listen(_onEventLocalAudioFile),
    );
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  @override
  Future<List<LocalAudioFile>?> loadEntity() async {
    final userId = await _authUserInfoProvider.getId();

    if (userId == null) {
      Logger.root.severe('User id is null, cannot load local audio files.');
      return null;
    }

    return _localAudioFileRepository.getAllByUserId(userId);
  }

  Future<void> onLocalAudioFilePressed(LocalAudioFile localAudioFile) async {
    final mediaItem = MediaItem(
      id: localAudioFile.id.toString(),
      title: localAudioFile.title,
      artist: localAudioFile.author,
      duration: localAudioFile.duration,
      artUri: localAudioFile.thumbnailPath != null ? Uri.parse(localAudioFile.thumbnailPath!) : null,
      extras: {
        'localPath': localAudioFile.path,
        'localAudioFileId': localAudioFile.id,
      },
    );

    await _audioHandler.updateQueue([]);
    await _audioHandler.insertQueueItem(0, mediaItem);
  }

  Future<void> _onEventLocalAudioFile(EventLocalAudioFile event) async {
    await event.when(
      downloaded: (localAudioFile) async {
        final newState = await state.modifyData((data) {
          final dataCopy = List.of(data);

          dataCopy.insert(0, localAudioFile);

          return dataCopy;
        });

        emit(newState);
      },
    );
  }
}
