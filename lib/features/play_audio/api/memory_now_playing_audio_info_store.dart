import 'package:injectable/injectable.dart';

import 'now_playing_audio_info_store.dart';

@LazySingleton(as: NowPlayingAudioInfoStore)
class MemoryNowPlayingAudioInfoStore implements NowPlayingAudioInfoStore {
  NowPlayingAudioInfo? _nowPlayingAudioInfo;

  @override
  Future<void> setNowPlayingAudioInfo(
    NowPlayingAudioInfo nowPlayingAudioInfo,
  ) {
    _nowPlayingAudioInfo = nowPlayingAudioInfo;

    return Future.value();
  }

  @override
  Future<NowPlayingAudioInfo?> getNowPlayingAudioInfo() {
    return Future.value(_nowPlayingAudioInfo);
  }

  @override
  Future<void> clearNowPlayingAudioInfo() {
    _nowPlayingAudioInfo = null;

    return Future.value();
  }
}
