import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../api/after_sign_in.dart';

part 'email_sign_in_state.freezed.dart';

@freezed
class EmailSignInState with _$EmailSignInState {
  const factory EmailSignInState({
    required Email email,
    required Password password,
    required ActionState<EmailSignInError> signInState,
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
    this._authRemoteRepository,
    this._afterSignIn,
  ) : super(EmailSignInState.initial());

  final AuthRemoteRepository _authRemoteRepository;
  final AfterSignIn _afterSignIn;

  void onEmailChanged(String value) {
    emit(state.copyWith(email: Email(value)));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: Password(password)));
  }

  void onDevSignIn() {
    if (!kDebugMode) {
      return;
    }

    emit(state.copyWith(email: Email('atheros098@gmail.com'), password: Password('password')));

    onSignInPressed();
  }

  Future<void> onSignInPressed() async {
    emit(state.copyWith(validateForm: true, signInState: ActionState.idle()));

    if (state.email.invalid || state.password.invalid) {
      return;
    }

    emit(state.copyWith(signInState: ActionState.executing()));

    await _authRemoteRepository
        .emailSignIn(email: state.email.getOrThrow, password: state.password.getOrThrow)
        .awaitFold(
      (l) => emit(state.copyWith(signInState: ActionState.failed(l))),
      (payload) async {
        emit(state.copyWith(signInState: ActionState.executed()));

        await _afterSignIn(tokenPayload: payload);
      },
    );
  }
}
