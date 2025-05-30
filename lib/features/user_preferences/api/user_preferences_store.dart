import 'package:domain_data/domain_data.dart';

abstract interface class UserPreferencesStore {
  Future<bool> isShuffleEnabled();

  Future<void> setShuffleEnabled(bool value);

  Future<bool> isRepeatEnabled();

  Future<void> setRepeatEnabled(bool value);

  Future<bool> isSaveShuffleStateEnabled();

  Future<void> setSaveShuffleStateEnabled(bool value);

  Future<bool> isSaveRepeatStateEnabled();

  Future<void> setSaveRepeatStateEnabled(bool value);

  Future<bool> isSearchHistoryEnabled();

  Future<void> setSearchHistoryEnabled(bool value);

  Future<int> getMaxConcurrentDownloadCount();

  Future<void> setMaxConcurrentDownloadCount(int value);

  Future<AudioSort> getAudioSort();

  Future<void> setAudioSort(AudioSort value);

  Future<void> clear();
}
