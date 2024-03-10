import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import 'after_sign_out.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  AfterSignOutImpl(
    this._pageNavigator,
  );

  final PageNavigator _pageNavigator;

  @override
  Future<void> call() async {
    _pageNavigator.toAuthPage();
  }
}
