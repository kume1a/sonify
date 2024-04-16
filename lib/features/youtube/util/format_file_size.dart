import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/intl/app_localizations.dart';

String formatFileSize(FileSize fileSize, AppLocalizations l) {
  final largestValue = _getLargestValue(fileSize).toStringAsFixed(1);
  final largestSymbol = _getLargestSymbol(fileSize, l);

  return '$largestValue$largestSymbol';
}

String _getLargestSymbol(FileSize fileSize, AppLocalizations appLocalizations) {
  if (fileSize.totalGigaBytes.abs() >= 1) {
    return appLocalizations.gb;
  }
  if (fileSize.totalMegaBytes.abs() >= 1) {
    return appLocalizations.mb;
  }
  if (fileSize.totalKiloBytes.abs() >= 1) {
    return appLocalizations.kb;
  }
  return appLocalizations.b;
}

num _getLargestValue(FileSize fileSize) {
  if (fileSize.totalGigaBytes.abs() >= 1) {
    return fileSize.totalGigaBytes;
  }
  if (fileSize.totalMegaBytes.abs() >= 1) {
    return fileSize.totalMegaBytes;
  }
  if (fileSize.totalKiloBytes.abs() >= 1) {
    return fileSize.totalKiloBytes;
  }
  return fileSize.totalBytes;
}
