import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../spotifyauth/api/spotify_creds_store.dart';
import 'after_sign_out.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  AfterSignOutImpl(
    this._pageNavigator,
    this._spotifyCredsStore,
    this._authUserInfoProvider,
    this._userSyncDatumLocalRepository,
  );

  final PageNavigator _pageNavigator;
  final SpotifyCredsStore _spotifyCredsStore;
  final AuthUserInfoProvider _authUserInfoProvider;
  final UserSyncDatumLocalRepository _userSyncDatumLocalRepository;

  @override
  Future<void> call() async {
    await Future.wait([
      _spotifyCredsStore.clear(),
      _authUserInfoProvider.clear(),
      _userSyncDatumLocalRepository.clear(),
    ]);

    _pageNavigator.toAuth();
  }
}
