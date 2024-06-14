import '../../app/intl/app_localizations.dart';

String formatBitrate(int speedInBytesPerSecond, AppLocalizations l) {
  final kilobytePerSecond = speedInBytesPerSecond / 1024;
  final megabytePerSecond = kilobytePerSecond / 1024;
  final gigabytePerSecond = megabytePerSecond / 1024;

  if (gigabytePerSecond >= 1) {
    return '${gigabytePerSecond.toStringAsFixed(1)} ${l.bitrateGBs}';
  }

  if (megabytePerSecond >= 1) {
    return '${megabytePerSecond.toStringAsFixed(1)} ${l.bitrateMBs}';
  }

  if (kilobytePerSecond >= 1) {
    return '${kilobytePerSecond.truncate()} ${l.bitrateKBs}';
  }

  return '$speedInBytesPerSecond ${l.bitrateBs}';
}

String formatFileSize(int fileSizeInBytes, AppLocalizations l) {
  final kilobytes = fileSizeInBytes / 1024;
  final megabytes = kilobytes / 1024;
  final gigabytes = megabytes / 1024;

  if (gigabytes >= 1) {
    return '${gigabytes.toStringAsFixed(1)} ${l.gb}';
  }

  if (megabytes >= 1) {
    return '${megabytes.toStringAsFixed(1)} ${l.mb}';
  }

  if (kilobytes >= 1) {
    return '${kilobytes.truncate()} ${l.kb}';
  }

  return '$fileSizeInBytes ${l.b}';
}
