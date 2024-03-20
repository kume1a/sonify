import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

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

extension DownloadYoutubeAudioFailureIntl on DownloadYoutubeAudioFailure {
  String translate(AppLocalizations l) {
    return when(
      network: () => l.noInternetConnection,
      unknown: () => l.unknownError,
      alreadyDownloaded: () => l.audioAlreadyDownloaded,
    );
  }
}
