import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../auth/api/auth_user_info_provider.dart';

part 'update_user_name_state.freezed.dart';

@freezed
class UpdateUserNameState with _$UpdateUserNameState {
  const factory UpdateUserNameState({
    required Name name,
    required bool validateForm,
    required ActionState<NetworkCallError> submitState,
  }) = _UpdateUserNameState;

  factory UpdateUserNameState.initial() => UpdateUserNameState(
        name: Name.empty(),
        validateForm: false,
        submitState: ActionState.idle(),
      );
}

extension UpdateUserNameCubitX on BuildContext {
  UpdateUserNameCubit get updateUserNameCubit => read<UpdateUserNameCubit>();
}

@injectable
class UpdateUserNameCubit extends Cubit<UpdateUserNameState> {
  UpdateUserNameCubit(
    this._userRemoteRepository,
    this._pageNavigator,
    this._authUserInfoProvider,
  ) : super(UpdateUserNameState.initial());

  final UserRemoteRepository _userRemoteRepository;
  final PageNavigator _pageNavigator;
  final AuthUserInfoProvider _authUserInfoProvider;

  void onNameChanged(String value) {
    emit(state.copyWith(name: Name(value)));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.name.invalid) {
      return;
    }

    emit(state.copyWith(submitState: ActionState.executing()));

    return _userRemoteRepository.updateUser(name: state.name.getOrThrow).awaitFold(
      (l) => emit(state.copyWith(submitState: ActionState.failed(l))),
      (user) async {
        emit(state.copyWith(submitState: ActionState.executed()));

        await _authUserInfoProvider.write(user);

        _pageNavigator.toMain();
      },
    );
  }
}
