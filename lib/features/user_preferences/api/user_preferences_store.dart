import '../../play_audio/model/audio_sort_by_option.dart';

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

  Future<AudioSortByOption> getAudioSortByOption();

  Future<void> setAudioSortByOption(AudioSortByOption value);

  Future<void> setSaveAudioSortByOptionEnabled(bool value);

  Future<bool> isSaveAudioSortByOptionEnabled();

  Future<void> clear();
}
