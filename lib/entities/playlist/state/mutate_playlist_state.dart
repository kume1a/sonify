import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/ui/toast_notifier.dart';
import '../model/event_user_playlist.dart';

part 'mutate_playlist_state.freezed.dart';

@freezed
class MutatePlaylistState with _$MutatePlaylistState {
  const factory MutatePlaylistState({
    required bool validateForm,
    required Name name,
    required bool isSubmitting,
  }) = _MutatePlaylistState;

  factory MutatePlaylistState.initial() => MutatePlaylistState(
        validateForm: false,
        name: Name.empty(),
        isSubmitting: false,
      );
}

extension MutatePlaylistCubitX on BuildContext {
  MutatePlaylistCubit get mutatePlaylistCubit => read<MutatePlaylistCubit>();
}

@injectable
class MutatePlaylistCubit extends Cubit<MutatePlaylistState> {
  MutatePlaylistCubit(
    this._saveUserPlaylistWithPlaylist,
    this._userPlaylistRemoteRepository,
    this._userPlaylistLocalRepository,
    this._toastNotifier,
    this._pageNavigator,
    this._eventBus,
  ) : super(MutatePlaylistState.initial());

  final SaveUserPlaylistWithPlaylist _saveUserPlaylistWithPlaylist;
  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final ToastNotifier _toastNotifier;
  final PageNavigator _pageNavigator;
  final EventBus _eventBus;

  String? _userPlaylistId;

  void init({required String? userPlaylistId}) {
    _userPlaylistId = userPlaylistId;

    _initPlaylist();
  }

  void onNameChanged(String value) {
    emit(state.copyWith(name: Name(value)));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.name.invalid) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    final name = state.name.getOrThrow;

    if (_userPlaylistId != null) {
      _updatePlaylist(userPlaylistId: _userPlaylistId!, name: name);
    } else {
      _createPlaylist(name: name);
    }
  }

  Future<void> _updatePlaylist({
    required String userPlaylistId,
    required String name,
  }) async {
    final remoteRes = await _userPlaylistRemoteRepository.updateById(
      id: _userPlaylistId!,
      name: name,
    );

    if (remoteRes.isLeft) {
      emit(state.copyWith(isSubmitting: false));

      _toastNotifier.error(description: (l) => l.failedToUpdatePlaylist);

      return;
    }

    final localRes = await _userPlaylistLocalRepository.updateById(
      id: _userPlaylistId!,
      name: name,
    );

    emit(state.copyWith(isSubmitting: false));

    localRes.fold(
      () => _toastNotifier.error(description: (l) => l.failedToCreatePlaylist),
      () {
        _eventBus.fire(EventUserPlaylist.updated(remoteRes.rightOrThrow));

        _toastNotifier.success(description: (l) => l.playlistUpdated(name));

        _pageNavigator.pop();
      },
    );
  }

  Future<void> _createPlaylist({
    required String name,
  }) async {
    final remoteRes = await _userPlaylistRemoteRepository.create(name: name);

    if (remoteRes.isLeft) {
      emit(state.copyWith(isSubmitting: false));

      _toastNotifier.error(description: (l) => l.failedToCreatePlaylist);

      return;
    }

    final localRes = await _saveUserPlaylistWithPlaylist(remoteRes.rightOrThrow);

    emit(state.copyWith(isSubmitting: false));

    localRes.fold(
      () => _toastNotifier.error(description: (l) => l.failedToCreatePlaylist),
      (r) {
        _eventBus.fire(EventUserPlaylist.created(r));

        _toastNotifier.success(description: (l) => l.playlistCreated(name));

        _pageNavigator.pop();
      },
    );
  }

  Future<void> _initPlaylist() async {
    if (_userPlaylistId == null) {
      return;
    }

    await _userPlaylistLocalRepository.getById(_userPlaylistId!).awaitFold(
      () => _toastNotifier.error(description: (l) => l.failedToLoadPlaylist),
      (r) {
        if (r == null) {
          _toastNotifier.warning(description: (l) => l.playlistNotFound);
          return;
        }

        emit(state.copyWith(name: Name(r.playlist?.name ?? '')));
      },
    );
  }
}
