import 'package:common_models/common_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../api/user_preferences_store.dart';

part 'user_preferences_state.freezed.dart';

@freezed
class UserPreferencesState with _$UserPreferencesState {
  const factory UserPreferencesState({
    required SimpleDataState<bool> isSaveShuffleStateEnabled,
    required SimpleDataState<bool> isSaveRepeatStateEnabled,
    required SimpleDataState<bool> isSearchHistoryEnabled,
  }) = _UserPreferencesState;

  factory UserPreferencesState.initial() => UserPreferencesState(
        isSaveShuffleStateEnabled: SimpleDataState.idle(),
        isSaveRepeatStateEnabled: SimpleDataState.idle(),
        isSearchHistoryEnabled: SimpleDataState.idle(),
      );
}

extension UserPreferencesCubitX on BuildContext {
  UserPreferencesCubit get userPreferencesCubit => read<UserPreferencesCubit>();
}

@injectable
class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  UserPreferencesCubit(
    this._userPreferencesStore,
  ) : super(UserPreferencesState.initial()) {
    _init();
  }

  final UserPreferencesStore _userPreferencesStore;

  Future<void> _init() async {
    emit(state.copyWith(
      isSaveShuffleStateEnabled: SimpleDataState.loading(),
      isSaveRepeatStateEnabled: SimpleDataState.loading(),
      isSearchHistoryEnabled: SimpleDataState.loading(),
    ));

    final isSaveShuffleStateEnabled = await _userPreferencesStore.isSaveShuffleStateEnabled();
    final isSaveRepeatStateEnabled = await _userPreferencesStore.isSaveRepeatStateEnabled();
    final isSearchHistoryEnabled = await _userPreferencesStore.isSearchHistoryEnabled();

    emit(state.copyWith(
      isSaveShuffleStateEnabled: SimpleDataState.success(isSaveShuffleStateEnabled),
      isSaveRepeatStateEnabled: SimpleDataState.success(isSaveRepeatStateEnabled),
      isSearchHistoryEnabled: SimpleDataState.success(isSearchHistoryEnabled),
    ));
  }

  Future<void> onToggleSaveShuffleState(bool value) async {
    emit(state.copyWith(isSaveShuffleStateEnabled: SimpleDataState.success(value)));
    await _userPreferencesStore.setSaveShuffleStateEnabled(value);
  }

  Future<void> onToggleSaveRepeatState(bool value) async {
    emit(state.copyWith(isSaveRepeatStateEnabled: SimpleDataState.success(value)));
    await _userPreferencesStore.setSaveRepeatStateEnabled(value);
  }

  Future<void> onToggleSearchHistory(bool value) async {
    emit(state.copyWith(isSearchHistoryEnabled: SimpleDataState.success(value)));
    await _userPreferencesStore.setSearchHistoryEnabled(value);
  }
}
