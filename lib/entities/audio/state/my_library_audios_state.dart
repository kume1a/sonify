import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/intl/extension/error_intl.dart';
import '../../../app/navigation/page_navigator.dart';
import '../../../features/play_audio/model/event_play_audio.dart';
import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../../../shared/ui/toast_notifier.dart';
import '../../../shared/values/assets.dart';
import '../model/event_user_audio.dart';

typedef MyLibraryAudiosState = SimpleDataState<List<UserAudio>>;

extension MyLibraryAudiosCubitX on BuildContext {
  MyLibraryAudiosCubit get myLibraryAudiosCubit => read<MyLibraryAudiosCubit>();
}

@injectable
final class MyLibraryAudiosCubit extends EntityLoaderCubit<List<UserAudio>> {
  MyLibraryAudiosCubit(
    this._userAudioLocalRepository,
    this._userAudioRemoteRepository,
    this._authUserInfoProvider,
    this._pageNavigator,
    this._bottomSheetManager,
    this._toastNotifier,
    this._eventBus,
  ) {
    _init();
  }

  final UserAudioLocalRepository _userAudioLocalRepository;
  final UserAudioRemoteRepository _userAudioRemoteRepository;
  final AuthUserInfoProvider _authUserInfoProvider;
  final PageNavigator _pageNavigator;
  final BottomSheetManager _bottomSheetManager;
  final ToastNotifier _toastNotifier;
  final EventBus _eventBus;

  final _subscriptions = SubscriptionComposite();

  void _init() {
    _subscriptions.addAll([
      _eventBus.on<EventUserAudio>().debounceTime(const Duration(seconds: 3)).listen(_onEventUserAudio),
    ]);

    loadEntityAndEmit();
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
      Logger.root.warning('User id is null, cannot load local audio files.');
      return null;
    }

    final res = await _userAudioLocalRepository.getAll(userId: userId);

    return res.dataOrNull;
  }

  void onSearchContainerPressed() {
    _pageNavigator.toMyLibrarySearch();
  }

  Future<void> onAudioMenuPressed(UserAudio userAudio) async {
    if (userAudio.audio?.id == null) {
      Logger.root.warning('MyLibraryAudiosCubit.onAudioMenuPressed: audio id is null');
      return;
    }

    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('MyLibraryAudiosCubit.onAudioMenuPressed: auth user id is null');
      return;
    }

    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (l) => userAudio.audio?.title ?? l.audio,
      options: [
        SelectOption(
          value: 0,
          label: (l) => l.delete,
          iconAssetName: Assets.svgTrashCan,
        ),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        return _triggerDeleteUserAudio(userAudio);
    }
  }

  Future<void> _onEventUserAudio(EventUserAudio event) async {
    await event.when(
      downloaded: (userAudio) async {
        if (userAudio.audio == null) {
          Logger.root.warning('User audio is null, cannot add to local audio files.');
          return;
        }

        // reload playlist to see newly downloaded audio in correct place
        loadEntityAndEmit(emitLoading: false);

        _eventBus.fire(
          const EventPlayAudio.reloadNowPlayingPlaylist(allowLocalAudioPlaylistReload: true),
        );
      },
    );
  }

  Future<void> _triggerDeleteUserAudio(UserAudio userAudio) async {
    if (userAudio.audioId == null || userAudio.id == null) {
      Logger.root.warning('MyLibraryAudiosCubit._triggerDeleteUserAudio: audioId or id is null', userAudio);
      return;
    }

    final res = await _userAudioRemoteRepository.deleteForAuthUser(audioId: userAudio.audioId!);
    if (res.isLeft) {
      _toastNotifier.error(description: (l) => res.leftOrThrow.translate(l));
      return;
    }

    await _userAudioLocalRepository.deleteById(userAudio.id!).awaitFold(
      () => _toastNotifier.error(description: (l) => l.failedToDelete, title: (l) => l.error),
      () async {
        final audios = await state.map((data) => List.of(data)..remove(userAudio));

        emit(audios);

        _eventBus.fire(
          const EventPlayAudio.reloadNowPlayingPlaylist(allowLocalAudioPlaylistReload: true),
        );
      },
    );
  }
}
