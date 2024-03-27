import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../api/after_sign_out.dart';

part 'sign_out_state.freezed.dart';

@freezed
class SignOutState with _$SignOutState {
  const factory SignOutState({
    required ActionState<ActionFailure> signOutState,
  }) = _SignOutState;

  factory SignOutState.initial() => SignOutState(
        signOutState: ActionState.idle(),
      );
}

extension SignOutCubitX on BuildContext {
  SignOutCubit get signOutCubit => read<SignOutCubit>();
}

@injectable
class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(
    this._authTokenStore,
    this._afterSignOut,
  ) : super(SignOutState.initial());

  final AuthTokenStore _authTokenStore;
  final AfterSignOut _afterSignOut;

  Future<void> onSignOutPressed() async {
    emit(state.copyWith(signOutState: ActionState.executing()));

    await _authTokenStore.clear();

    emit(state.copyWith(signOutState: ActionState.executed()));

    _afterSignOut();
  }
}
