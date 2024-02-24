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

extension NameFailureIntl on NameFailure {
  String translate(AppLocalizations l) {
    return when(
      empty: () => l.fieldIsRequired,
      tooLong: () => l.nameIsTooLong,
      tooShort: () => l.nameIsTooShort,
    );
  }
}
