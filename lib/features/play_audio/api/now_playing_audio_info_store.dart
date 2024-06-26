final class NowPlayingAudioInfo {
  NowPlayingAudioInfo({
    required this.audioId,
    required this.playlistId,
    required this.position,
  });

  final String? audioId;
  final String? playlistId;
  final Duration position;
}

abstract interface class NowPlayingAudioInfoStore {
  Future<void> setNowPlayingAudioInfo(
    NowPlayingAudioInfo nowPlayingAudioInfo,
  );

  Future<NowPlayingAudioInfo?> getNowPlayingAudioInfo();

  Future<void> clearNowPlayingAudioInfo();
}
