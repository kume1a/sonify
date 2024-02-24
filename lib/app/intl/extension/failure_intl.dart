import 'package:common_models/common_models.dart';

import '../app_localizations.dart';

extension ActionFailureIntl on ActionFailure {
  String translate(AppLocalizations l) {
    return when(
      unknown: () => l.unknownError,
      network: () => l.noInternetConnection,
    );
  }
}
