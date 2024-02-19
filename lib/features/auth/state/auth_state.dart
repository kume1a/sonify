import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../api/auth_status_provider.dart';
import '../api/auth_with_google.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required SimpleDataState<bool> isAuthenticated,
  }) = _AuthState;

  factory AuthState.initial() => AuthState(
        isAuthenticated: SimpleDataState.idle(),
      );
}

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authWithGoogle,
    this._authStatusProvider,
  ) : super(AuthState.initial()) {
    _init();
  }

  final AuthWithGoogle _authWithGoogle;
  final AuthStatusProvider _authStatusProvider;

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
  }
}
