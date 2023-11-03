import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/intl/app_localizations.dart';

String formatBitrate(Bitrate bitrate, AppLocalizations l) {
  final largestValue = _getLargestValue(bitrate).toStringAsFixed(1);
  final largestSymbol = _getLargestSymbol(bitrate, l);

  return '$largestValue$largestSymbol';
}

String _getLargestSymbol(Bitrate bitrate, AppLocalizations appLocalizations) {
  if (bitrate.gigaBitsPerSecond.abs() >= 1) {
    return appLocalizations.bitrateGB;
  }
  if (bitrate.megaBitsPerSecond.abs() >= 1) {
    return appLocalizations.bitrateMB;
  }
  if (bitrate.kiloBitsPerSecond.abs() >= 1) {
    return appLocalizations.bitrateKB;
  }
  return appLocalizations.bitrateB;
}

num _getLargestValue(Bitrate bitrate) {
  if (bitrate.gigaBitsPerSecond.abs() >= 1) {
    return bitrate.gigaBitsPerSecond;
  }
  if (bitrate.megaBitsPerSecond.abs() >= 1) {
    return bitrate.megaBitsPerSecond;
  }
  if (bitrate.kiloBitsPerSecond.abs() >= 1) {
    return bitrate.kiloBitsPerSecond;
  }
  return bitrate.bitsPerSecond;
}
