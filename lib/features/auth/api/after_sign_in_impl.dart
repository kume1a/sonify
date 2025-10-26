import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/util/utils.dart';
import '../model/auth_event.dart';
import 'after_sign_in.dart';

@LazySingleton(as: AfterSignIn)
class AfterSignInImpl implements AfterSignIn {
  AfterSignInImpl(
    this._authUserInfoProvider,
    this._authTokenStore,
    this._pageNavigator,
    this._eventBus,
  );

  final AuthUserInfoProvider _authUserInfoProvider;
  final AuthTokenStore _authTokenStore;
  final PageNavigator _pageNavigator;
  final EventBus _eventBus;

  @override
  Future<void> call({
    required TokenPayload tokenPayload,
  }) async {
    await _authTokenStore.writeAccessToken(tokenPayload.accessToken);

    final user = tokenPayload.user;
    if (user == null) {
      Logger.root.warning('AfterSignIn.call: user is null, $tokenPayload');
      return;
    }

    await _authUserInfoProvider.write(tokenPayload.user!);

    _eventBus.fire(const AuthEvent.userSignedIn());

    if (user.name.isNullOrEmpty) {
      _pageNavigator.toUserName();
    } else {
      _pageNavigator.toMain();
    }
  }
}
