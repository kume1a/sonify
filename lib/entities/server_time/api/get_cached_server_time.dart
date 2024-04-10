import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import 'get_server_time.dart';
import 'server_time_offset_store.dart';

class _ServerTimeDiffInMemoryCache {
  int? _value;

  int? get valueInMillis => _value;

  set value(int newValue) {
    if (_value != null) {
      throw Exception("Can't set cached value twice");
    }

    _value = newValue;
  }
}

@LazySingleton(as: GetServerTime)
class GetCachedServerTime implements GetServerTime {
  GetCachedServerTime(
    this._serverTimeRemoteRepository,
    this._serverTimeOffsetStore,
  );

  final ServerTimeRemoteRepository _serverTimeRemoteRepository;
  final ServerTimeOffsetStore _serverTimeOffsetStore;

  final _serverTimeOffsetInMemoryCache = _ServerTimeDiffInMemoryCache();

  /// Get cached server timestamp
  ///
  /// Execution order
  /// * Try to get timestamp from server on every application launch (since it's singleton)
  /// * Store that value in inMemoryCache and shared preferences
  /// * If for some reason can't get from server, read from shared prefs
  /// * If local storage doesn't a value, return local time
  @override
  Future<DateTime> call() async {
    final inMemoryCachedDiff = _serverTimeOffsetInMemoryCache.valueInMillis;

    if (inMemoryCachedDiff != null) {
      return _localTimeWithOffset(inMemoryCachedDiff);
    }

    final remoteServerTimestamp = await _serverTimeRemoteRepository.getServerTime();

    if (remoteServerTimestamp.isRight) {
      final offsetInMillis = _calculateServerTimeOffset(remoteServerTimestamp.rightOrThrow);

      if (offsetInMillis != null) {
        _serverTimeOffsetInMemoryCache.value = offsetInMillis;
        _serverTimeOffsetStore.write(offsetInMillis);

        return _localTimeWithOffset(offsetInMillis);
      }
    }

    final cachedOffset = _serverTimeOffsetStore.read();

    if (cachedOffset != null) {
      return _localTimeWithOffset(cachedOffset);
    }

    return DateTime.now();
  }

  static DateTime _localTimeWithOffset(int offsetInMillis) {
    final offset = Duration(milliseconds: offsetInMillis);

    return DateTime.now().add(offset);
  }

  static int? _calculateServerTimeOffset(ServerTime serverTime) {
    final diff = serverTime.time?.difference(DateTime.now());

    return diff?.inMilliseconds;
  }
}
