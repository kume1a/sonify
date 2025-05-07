import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_preferences_store.dart';

@LazySingleton(as: UserPreferencesStore)
class SharedprefsUserPreferencesStore implements UserPreferencesStore {
  SharedprefsUserPreferencesStore(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  static const _keyIsRepeatEnabled = 'is_repeat_enabled';
  static const _keyIsShuffleEnabled = 'is_shuffle_enabled';
  static const _keyIsSaveRepeatStateEnabled = 'is_save_repeat_state_enabled';
  static const _keyIsSaveShuffleStateEnabled = 'is_save_shuffle_state_enabled';
  static const _keyIsSearchHistoryEnabled = 'is_search_history_enabled';
  static const _keyMaxConcurrentDownloadCount = 'max_concurrent_download_count';
  static const _keyAudioSort = 'audio_sort';

  @override
  Future<bool> isRepeatEnabled() {
    final value = _sharedPreferences.getBool(_keyIsRepeatEnabled);

    return Future.value(value ?? false);
  }

  @override
  Future<bool> isSaveRepeatStateEnabled() {
    final value = _sharedPreferences.getBool(_keyIsSaveRepeatStateEnabled);

    return Future.value(value ?? false);
  }

  @override
  Future<bool> isSaveShuffleStateEnabled() {
    final value = _sharedPreferences.getBool(_keyIsSaveShuffleStateEnabled);

    return Future.value(value ?? false);
  }

  @override
  Future<bool> isSearchHistoryEnabled() {
    final value = _sharedPreferences.getBool(_keyIsSearchHistoryEnabled);

    return Future.value(value ?? false);
  }

  @override
  Future<bool> isShuffleEnabled() {
    final value = _sharedPreferences.getBool(_keyIsShuffleEnabled);

    return Future.value(value ?? false);
  }

  @override
  Future<void> setRepeatEnabled(bool value) {
    return _sharedPreferences.setBool(_keyIsRepeatEnabled, value);
  }

  @override
  Future<void> setSaveRepeatStateEnabled(bool value) {
    return _sharedPreferences.setBool(_keyIsSaveRepeatStateEnabled, value);
  }

  @override
  Future<void> setSaveShuffleStateEnabled(bool value) {
    return _sharedPreferences.setBool(_keyIsSaveShuffleStateEnabled, value);
  }

  @override
  Future<void> setSearchHistoryEnabled(bool value) {
    return _sharedPreferences.setBool(_keyIsSearchHistoryEnabled, value);
  }

  @override
  Future<void> setShuffleEnabled(bool value) {
    return _sharedPreferences.setBool(_keyIsShuffleEnabled, value);
  }

  @override
  Future<int> getMaxConcurrentDownloadCount() {
    final value = _sharedPreferences.getInt(_keyMaxConcurrentDownloadCount);

    return Future.value(value ?? 1);
  }

  @override
  Future<void> setMaxConcurrentDownloadCount(int value) {
    return _sharedPreferences.setInt(_keyMaxConcurrentDownloadCount, value);
  }

  @override
  Future<AudioSort> getAudioSort() {
    final value = _sharedPreferences.getInt(_keyAudioSort);

    if (value == null) {
      return Future.value(AudioSort.title);
    }

    return Future.value(AudioSort.values[value]);
  }

  @override
  Future<void> setAudioSort(AudioSort value) {
    return _sharedPreferences.setInt(_keyAudioSort, value.index);
  }

  @override
  Future<void> clear() {
    return Future.wait([
      _sharedPreferences.remove(_keyIsRepeatEnabled),
      _sharedPreferences.remove(_keyIsShuffleEnabled),
      _sharedPreferences.remove(_keyIsSaveRepeatStateEnabled),
      _sharedPreferences.remove(_keyIsSaveShuffleStateEnabled),
      _sharedPreferences.remove(_keyIsSearchHistoryEnabled),
      _sharedPreferences.remove(_keyMaxConcurrentDownloadCount),
      _sharedPreferences.remove(_keyAudioSort),
    ]);
  }
}
