import 'now_playing_audio_info_store.dart';

// @LazySingleton(as: NowPlayingAudioInfoStore)
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

  @override
  Future<void> setNowPlayingAudioInfoPosition(Duration position) {
    if (_nowPlayingAudioInfo == null) {
      return Future.value();
    }

    _nowPlayingAudioInfo = NowPlayingAudioInfo(
      audioId: _nowPlayingAudioInfo!.audioId,
      playlistId: _nowPlayingAudioInfo!.playlistId,
      position: position,
    );

    return Future.value();
  }
}
