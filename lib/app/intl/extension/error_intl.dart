import 'package:common_models/common_models.dart';
import 'package:sonify_client/sonify_client.dart';

import '../app_localizations.dart';

extension NetworkCallErrorIntl on NetworkCallError {
  String translate(AppLocalizations l) {
    return when(
      unknown: () => l.unknownError,
      network: () => l.noInternetConnection,
      internalServer: () => l.internalServerError,
    );
  }
}

extension NameErrorIntl on NameError {
  String translate(AppLocalizations l) {
    return when(
      empty: () => l.fieldIsRequired,
      tooLong: () => l.nameIsTooLong,
      tooShort: () => l.nameIsTooShort,
    );
  }
}

extension EmailErrorIntl on EmailError {
  String translate(AppLocalizations l) {
    return when(
      empty: () => l.fieldIsRequired,
      tooLong: () => l.emailIsTooLong,
      containsWhitespace: () => l.emailContainsWhitespace,
      invalid: () => l.emailIsInvalid,
    );
  }
}

extension PasswordErrorIntl on PasswordError {
  String translate(AppLocalizations l) {
    return maybeWhen(
      orElse: () => '',
      empty: () => l.fieldIsRequired,
      tooLong: () => l.passwordIsTooShort,
      tooShort: () => l.passwordIsTooShort,
      containsWhitespace: () => l.passwordContainsWhitespace,
    );
  }
}

extension DownloadYoutubeAudioErrorIntl on DownloadYoutubeAudioError {
  String translate(AppLocalizations l) {
    return when(
      network: () => l.noInternetConnection,
      unknown: () => l.unknownError,
      alreadyDownloaded: () => l.audioAlreadyDownloaded,
    );
  }
}

extension EmailSignInErrorIntl on EmailSignInError {
  String translate(AppLocalizations l) {
    return when(
      invalidEmailOrPassword: () => l.invalidEmailOrPassword,
      invalidAuthMethod: () => l.emailAlreadyUsedWithDifferentAuthProvider,
      network: () => l.noInternetConnection,
      unknown: () => l.unknownError,
    );
  }
}

extension CreatePlaylistAudioErrorIntl on CreatePlaylistAudioError {
  String translate(AppLocalizations l, String playlistName) {
    return when(
      network: () => l.noInternetConnection,
      unknown: () => l.unknownError,
      alreadyExists: () => l.audioAlreadyInPlaylist(playlistName),
    );
  }
}
