import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../spotifyauth/api/spotify_creds_store.dart';
import 'after_sign_out.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  AfterSignOutImpl(
    this._pageNavigator,
    this._spotifyCredsStore,
  );

  final PageNavigator _pageNavigator;
  final SpotifyCredsStore _spotifyCredsStore;

  @override
  Future<void> call() async {
    await _spotifyCredsStore.clear();

    _pageNavigator.toAuth();
  }
}
