import 'package:app_links/app_links.dart';
import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/util/intent.dart';
import '../../../shared/values/constant.dart';
import '../api/spotify_api.dart';
import '../api/spotify_creds_store.dart';

part 'spotify_auth_state.freezed.dart';

@freezed
class SpotifyAuthState with _$SpotifyAuthState {
  const factory SpotifyAuthState({
    required SimpleDataState<bool> isSpotifyAuthenticated,
  }) = _SpotifyAuthState;

  factory SpotifyAuthState.initial() => SpotifyAuthState(
        isSpotifyAuthenticated: SimpleDataState.idle(),
      );
}

extension SpotifyAuthCubitX on BuildContext {
  SpotifyAuthCubit get authSpotifyCubit => read<SpotifyAuthCubit>();
}

@injectable
class SpotifyAuthCubit extends Cubit<SpotifyAuthState> {
  SpotifyAuthCubit(
    this._spotifyApi,
    this._intentLauncher,
    this._spotifyCredsStore,
    this._spotifyAuthRepository,
    this._appLinks,
  ) : super(SpotifyAuthState.initial()) {
    _init();
  }

  final SpotifyApi _spotifyApi;
  final IntentLauncher _intentLauncher;
  final SpotifyCredsStore _spotifyCredsStore;
  final SpotifyAuthRepository _spotifyAuthRepository;
  final AppLinks _appLinks;

  final _subscriptions = SubscriptionComposite();

  Future<void> _init() async {
    await Future.wait([
      _loadSpotifyAuthState(),
      _initDeepLinks(),
    ]);
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  Future<void> onAuthorizePressed() async {
    final authorizationUri = _spotifyApi.getAuthorizationUrl();

    Logger.root.info('Launching Spotify authorization URI: $authorizationUri');

    await _intentLauncher.launchUri(authorizationUri);
  }

  Future<void> _loadSpotifyAuthState() async {
    emit(state.copyWith(isSpotifyAuthenticated: SimpleDataState.loading()));

    final spotifyRefreshToken = _spotifyCredsStore.readRefreshToken();
    final isAuthenticated = spotifyRefreshToken != null && spotifyRefreshToken.isNotEmpty;

    emit(state.copyWith(isSpotifyAuthenticated: SimpleDataState.success(isAuthenticated)));
  }

  Future<void> _initDeepLinks() async {
    _subscriptions.add(
      _appLinks.allUriLinkStream.listen(_handleSpotifyCallbackDeepLink),
    );

    // final appLink = await _appLinks.getInitialAppLink();
    // if (appLink != null) {
    //   return _handleSpotifyCallbackDeepLink(appLink);
    // }
  }

  Future<void> _handleSpotifyCallbackDeepLink(Uri uri) async {
    if (!uri.toString().startsWith(kSpotifyCallbackUrl)) {
      return;
    }

    final code = uri.queryParameters['code'];
    if (code == null) {
      return;
    }

    return _authorizeSpotifyToken(code);
  }

  Future<void> _authorizeSpotifyToken(String code) async {
    await _spotifyAuthRepository.authorizeSpotify(code: code).awaitFold(
      (l) {
        emit(state.copyWith(isSpotifyAuthenticated: SimpleDataState.success(false)));
      },
      (r) async {
        if (r.refreshToken.isEmpty || r.accessToken.isEmpty || r.expiresIn == 0) {
          emit(state.copyWith(isSpotifyAuthenticated: SimpleDataState.success(false)));

          return;
        }

        await Future.wait([
          _spotifyCredsStore.writeRefreshToken(r.refreshToken),
          _spotifyCredsStore.writeAccessToken(r.accessToken),
          _spotifyCredsStore.writeTokenExpiresIn(r.expiresIn),
        ]);
        Logger.root.fine('Spotify token authorized successfully.');
        emit(state.copyWith(isSpotifyAuthenticated: SimpleDataState.success(true)));
      },
    );
  }
}
