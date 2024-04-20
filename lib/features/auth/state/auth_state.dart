import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/util/utils.dart';
import '../api/after_sign_in.dart';
import '../api/auth_with_google.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required SimpleDataState<bool> isAuthenticated,
    required ActionState<Unit> googleSignInAction,
  }) = _AuthState;

  factory AuthState.initial() =>
      AuthState(isAuthenticated: SimpleDataState.idle(), googleSignInAction: ActionState.idle());
}

extension AuthCubitX on BuildContext {
  AuthCubit get authCubit => read<AuthCubit>();
}

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authWithGoogle,
    this._authStatusProvider,
    this._authRemoteRepository,
    this._pageNavigator,
    this._afterSignIn,
    this._authUserInfoProvider,
  ) : super(AuthState.initial()) {
    _init();
  }

  final AuthWithGoogle _authWithGoogle;
  final AuthStatusProvider _authStatusProvider;
  final AuthRemoteRepository _authRemoteRepository;
  final PageNavigator _pageNavigator;
  final AfterSignIn _afterSignIn;
  final AuthUserInfoProvider _authUserInfoProvider;

  Future<void> _init() async {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    emit(state.copyWith(
      isAuthenticated: SimpleDataState.loading(),
    ));

    final isAuthenticated = await _authStatusProvider.get();

    emit(state.copyWith(
      isAuthenticated: SimpleDataState.success(isAuthenticated),
    ));

    if (isAuthenticated) {
      final authUserInfo = await _authUserInfoProvider.read();
      if (authUserInfo == null) {
        Logger.root.warning('authUserInfo is null while isAuthenticated is true.');
        return;
      }

      if (authUserInfo.name.isNullOrEmpty) {
        _pageNavigator.toUserName();
      } else {
        _pageNavigator.toMain();
      }
    }
  }

  Future<void> onGoogleSignIn() async {
    emit(state.copyWith(
      googleSignInAction: ActionState.executing(),
    ));

    final googleAccount = await _authWithGoogle();
    if (googleAccount == null) {
      emit(state.copyWith(googleSignInAction: ActionState.failed(unit)));
      return;
    }

    final googleAuthentication = await googleAccount.authentication;

    if (googleAuthentication.idToken == null) {
      emit(state.copyWith(googleSignInAction: ActionState.failed(unit)));
      return;
    }

    await _authRemoteRepository.googleSignIn(token: googleAuthentication.idToken!).awaitFold(
      (l) => emit(state.copyWith(googleSignInAction: ActionState.failed(unit))),
      (tokenPayload) async {
        emit(state.copyWith(googleSignInAction: ActionState.executed()));

        await _afterSignIn(tokenPayload: tokenPayload);
      },
    );
  }

  void onEmailSignIn() {
    _pageNavigator.toEmailSignIn();
  }
}
