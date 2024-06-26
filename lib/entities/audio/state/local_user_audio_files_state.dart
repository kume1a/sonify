import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../model/event_user_audio.dart';

typedef LocalUserAudioFilesState = SimpleDataState<List<Audio>>;

extension LocalAudioFilesCubitX on BuildContext {
  LocalUserAudioFilesCubit get localAudioFilesCubit => read<LocalUserAudioFilesCubit>();
}

@injectable
final class LocalUserAudioFilesCubit extends EntityLoaderCubit<List<Audio>> {
  LocalUserAudioFilesCubit(
    this._audioLocalRepository,
    this._authUserInfoProvider,
    this._eventBus,
    this._pageNavigator,
  ) {
    _init();

    loadEntityAndEmit();
  }

  final UserAudioLocalRepository _audioLocalRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final EventBus _eventBus;
  final PageNavigator _pageNavigator;

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
  Future<List<Audio>?> loadEntity() async {
    final userId = await _authUserInfoProvider.getId();

    if (userId == null) {
      Logger.root.warning('User id is null, cannot load local audio files.');
      return null;
    }

    final res = await _audioLocalRepository.getAll(userId: userId);

    return res.dataOrNull?.map((e) => e.audio).whereNotNull().toList();
  }

  void onSearchContainerPressed() {
    _pageNavigator.toMyLibrarySearch();
  }

  Future<void> _onEventUserAudio(EventUserAudio event) async {
    await event.when(
      downloaded: (userAudio) async {
        if (userAudio.audio == null) {
          Logger.root.warning('User audio is null, cannot add to local audio files.');
          return;
        }

        final newState = await state.map((data) {
          final dataCopy = List.of(data);

          dataCopy.insert(0, userAudio.audio!);

          return dataCopy;
        });

        emit(newState);
      },
    );
  }
}
