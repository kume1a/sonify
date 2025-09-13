import 'package:domain_data/domain_data.dart';

abstract interface class UserPreferencesStore {
  bool isShuffleEnabled();

  Future<void> setShuffleEnabled(bool value);

  bool isRepeatEnabled();

  Future<void> setRepeatEnabled(bool value);

  bool isSaveShuffleStateEnabled();

  Future<void> setSaveShuffleStateEnabled(bool value);

  bool isSaveRepeatStateEnabled();

  Future<void> setSaveRepeatStateEnabled(bool value);

  bool isSearchHistoryEnabled();

  Future<void> setSearchHistoryEnabled(bool value);

  int getMaxConcurrentDownloadCount();

  Future<void> setMaxConcurrentDownloadCount(int value);

  AudioSort getAudioSort();

  Future<void> setAudioSort(AudioSort value);

  Future<void> clear();
}
