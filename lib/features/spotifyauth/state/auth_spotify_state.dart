import 'package:common_models/common_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/intent.dart';
import '../api/spotify_api.dart';

part 'auth_spotify_state.freezed.dart';

@freezed
class AuthSpotifyState with _$AuthSpotifyState {
  const factory AuthSpotifyState({
    required ActionState<ActionFailure> authState,
  }) = _AuthSpotifyState;

  factory AuthSpotifyState.initial() => AuthSpotifyState(
        authState: ActionState.idle(),
      );
}

extension AuthSpotifyCubitX on BuildContext {
  AuthSpotifyCubit get authSpotifyCubit => read<AuthSpotifyCubit>();
}

@injectable
class AuthSpotifyCubit extends Cubit<AuthSpotifyState> {
  AuthSpotifyCubit(
    this._spotifyApi,
    this._intentLauncher,
  ) : super(AuthSpotifyState.initial());

  final SpotifyApi _spotifyApi;
  final IntentLauncher _intentLauncher;

  Future<void> onAuthorizePressed() async {
    final authorizationUri = _spotifyApi.getAuthorizationUrl();

    await _intentLauncher.launchUri(authorizationUri);
  }
}
