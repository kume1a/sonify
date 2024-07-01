import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../spotifyauth/api/spotify_creds_store.dart';
import 'after_sign_out.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  AfterSignOutImpl(
    this._pageNavigator,
    this._authTokenStore,
    this._spotifyCredsStore,
    this._authUserInfoProvider,
    this._userSyncDatumLocalRepository,
    this._socketProvider,
  );

  final PageNavigator _pageNavigator;
  final AuthTokenStore _authTokenStore;
  final SpotifyCredsStore _spotifyCredsStore;
  final AuthUserInfoProvider _authUserInfoProvider;
  final UserSyncDatumLocalRepository _userSyncDatumLocalRepository;
  final SocketProvider _socketProvider;

  @override
  Future<void> call() async {
    await Future.wait([
      _authTokenStore.clear(),
      _spotifyCredsStore.clear(),
      _authUserInfoProvider.clear(),
      _userSyncDatumLocalRepository.clear(),
      _socketProvider.dispose(),
    ]);

    _pageNavigator.toAuth();
  }
}
