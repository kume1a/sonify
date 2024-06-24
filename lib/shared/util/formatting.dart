import '../../app/intl/app_localizations.dart';

class _LocalizedBitrate {
  _LocalizedBitrate({
    required this.bitrateBs,
    required this.bitrateKBs,
    required this.bitrateMBs,
    required this.bitrateGBs,
  });
  final String bitrateBs;
  final String bitrateKBs;
  final String bitrateMBs;
  final String bitrateGBs;
}

class _LocalizedFileSize {
  _LocalizedFileSize({
    required this.b,
    required this.kb,
    required this.mb,
    required this.gb,
  });

  final String b;
  final String kb;
  final String mb;
  final String gb;
}

String formatBitrateEn(int speedInBytesPerSec) {
  return _formatBitrateRaw(
    speedInBytesPerSec,
    _LocalizedBitrate(
      bitrateBs: 'B/s',
      bitrateKBs: 'KB/s',
      bitrateMBs: 'MB/s',
      bitrateGBs: 'GB/s',
    ),
  );
}

String formatBitrateLocalized(int speedInBytesPerSecond, AppLocalizations l) {
  return _formatBitrateRaw(
    speedInBytesPerSecond,
    _LocalizedBitrate(
      bitrateBs: l.bitrateBs,
      bitrateKBs: l.bitrateKBs,
      bitrateMBs: l.bitrateMBs,
      bitrateGBs: l.bitrateGBs,
    ),
  );
}

String formatFileSizeEn(int fileSizeInBytes) {
  return _formatFileSizeRaw(
    fileSizeInBytes,
    _LocalizedFileSize(
      b: 'B',
      kb: 'KB',
      mb: 'MB',
      gb: 'GB',
    ),
  );
}

String formatFileSizeLocalized(int fileSizeInBytes, AppLocalizations l) {
  return _formatFileSizeRaw(
    fileSizeInBytes,
    _LocalizedFileSize(
      b: l.b,
      kb: l.kb,
      mb: l.mb,
      gb: l.gb,
    ),
  );
}

String _formatBitrateRaw(int speedInBytesPerSec, _LocalizedBitrate l) {
  final kilobytePerSecond = speedInBytesPerSec / 1024;
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

  return '$speedInBytesPerSec ${l.bitrateBs}';
}

String _formatFileSizeRaw(int fileSizeInBytes, _LocalizedFileSize l) {
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
