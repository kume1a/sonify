import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/auth/api/auth_user_info_provider.dart';
import '../../../features/play_audio/util/enqueue_audio.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../model/event_user_audio.dart';

typedef LocalAudioFilesState = SimpleDataState<List<UserAudio>>;

extension LocalAudioFilesCubitX on BuildContext {
  LocalAudioFilesCubit get localAudioFilesCubit => read<LocalAudioFilesCubit>();
}

@injectable
final class LocalAudioFilesCubit extends EntityLoaderCubit<List<UserAudio>> {
  LocalAudioFilesCubit(
    this._audioLocalRepository,
    this._authUserInfoProvider,
    this._eventBus,
    this._enqueueAudio,
  ) {
    _init();

    loadEntityAndEmit();
  }

  final AudioLocalRepository _audioLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final EventBus _eventBus;
  final EnqueueAudio _enqueueAudio;

  final _subscriptions = SubscriptionComposite();

  void _init() {
    _subscriptions.add(
      _eventBus.on<EventUserAudio>().listen(_onEventUserAudio),
    );
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  @override
  Future<List<UserAudio>?> loadEntity() async {
    final userId = await _authUserInfoProvider.getId();

    if (userId == null) {
      Logger.root.severe('User id is null, cannot load local audio files.');
      return null;
    }

    return _audioLocalRepository.getAllByUserId(userId);
  }

  Future<void> onUserAudioFilePressed(UserAudio userAudio) async {
    if (userAudio.audio == null) {
      Logger.root.warning('Audio is null, cannot enqueue audio.');
      return;
    }

    return _enqueueAudio.call(userAudio.audio!);
  }

  Future<void> _onEventUserAudio(EventUserAudio event) async {
    await event.when(
      downloaded: (audio) async {
        final newState = await state.modifyData((data) {
          final dataCopy = List.of(data);

          dataCopy.insert(0, audio);

          return dataCopy;
        });

        emit(newState);
      },
    );
  }

  void onSearchQueryChanged(String value) {}
}
