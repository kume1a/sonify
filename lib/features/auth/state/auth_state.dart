import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/navigation/page_navigator.dart';
import '../api/auth_status_provider.dart';
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
    this._authRepository,
    this._pageNavigator,
    this._authTokenStore,
    this._userRemoteRepository,
  ) : super(AuthState.initial()) {
    _init();
  }

  final AuthWithGoogle _authWithGoogle;
  final AuthStatusProvider _authStatusProvider;
  final AuthRepository _authRepository;
  final PageNavigator _pageNavigator;
  final AuthTokenStore _authTokenStore;
  final UserRemoteRepository _userRemoteRepository;

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
      await _userRemoteRepository.getAuthUser().awaitFold(
        (_) => _pageNavigator.toMain(),
        (r) {
          if (r.name.isEmpty) {
            _pageNavigator.toUserName();
          } else {
            _pageNavigator.toMain();
          }
        },
      );
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

    await _authRepository.googleSignIn(googleAuthentication.idToken!).awaitFold(
      (l) => emit(state.copyWith(googleSignInAction: ActionState.failed(unit))),
      (tokenPayload) async {
        emit(state.copyWith(googleSignInAction: ActionState.executed()));

        await _authTokenStore.writeAccessToken(tokenPayload.accessToken);

        if (tokenPayload.user?.name.isEmpty == true) {
          _pageNavigator.toUserName();
        } else {
          _pageNavigator.toMain();
        }
      },
    );
  }

  void onEmailSignIn() {
    _pageNavigator.toEmailSignIn();
  }
}
