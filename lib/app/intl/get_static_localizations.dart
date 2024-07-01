import 'package:global_navigator/global_navigator.dart';

import 'app_localizations.dart';

AppLocalizations? getStaticLocalizations() {
  final c = GlobalNavigator.context;

  if (c == null) {
    return null;
  }

  return AppLocalizations.of(c);
}
