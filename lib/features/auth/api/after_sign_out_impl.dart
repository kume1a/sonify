import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../spotifyauth/api/spotify_creds_store.dart';
import 'after_sign_out.dart';
import 'auth_user_info_provider.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  AfterSignOutImpl(
    this._pageNavigator,
    this._spotifyCredsStore,
    this._authUserInfoProvider,
  );

  final PageNavigator _pageNavigator;
  final SpotifyCredsStore _spotifyCredsStore;
  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<void> call() async {
    await Future.wait([
      _spotifyCredsStore.clear(),
      _authUserInfoProvider.clear(),
    ]);

    _pageNavigator.toAuth();
  }
}
