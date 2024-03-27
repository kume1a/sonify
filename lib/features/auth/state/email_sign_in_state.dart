import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/navigation/page_navigator.dart';

part 'email_sign_in_state.freezed.dart';

@freezed
class EmailSignInState with _$EmailSignInState {
  const factory EmailSignInState({
    required Email email,
    required Password password,
    required ActionState<ActionFailure> signInState,
    required bool validateForm,
  }) = _EmailSignInState;

  factory EmailSignInState.initial() => EmailSignInState(
        email: Email.empty(),
        password: Password.empty(),
        signInState: ActionState.idle(),
        validateForm: false,
      );
}

extension EmailSignInStateX on BuildContext {
  EmailSignInCubit get emailSignInCubit => read<EmailSignInCubit>();
}

@injectable
class EmailSignInCubit extends Cubit<EmailSignInState> {
  EmailSignInCubit(
    this._authRepository,
    this._authTokenStore,
    this._pageNavigator,
  ) : super(EmailSignInState.initial());

  final AuthRepository _authRepository;
  final AuthTokenStore _authTokenStore;
  final PageNavigator _pageNavigator;

  void onEmailChanged(String value) {
    emit(state.copyWith(email: Email(value)));
  }

  void onPasswordChanged(String password) {
    final Password newPassword = Password(password);
    emit(state.copyWith(password: newPassword, validateForm: true));
  }

  Future<void> onEmailSignIn() async {
    emit(state.copyWith(validateForm: true, signInState: ActionState.idle()));

    if (state.email.invalid || state.password.invalid) {
      return;
    }

    emit(state.copyWith(signInState: ActionState.executing()));

    await _authRepository
        .emailSignIn(email: state.email.getOrThrow, password: state.password.getOrThrow)
        .awaitFold(
      (l) => emit(state.copyWith(signInState: ActionState.failed(l))),
      (payload) async {
        emit(state.copyWith(signInState: ActionState.executed()));

        await _authTokenStore.writeAccessToken(payload.accessToken);

        if (payload.user?.name.isEmpty == true) {
          _pageNavigator.toUserName();
        } else {
          _pageNavigator.toMain();
        }
      },
    );
  }
}
