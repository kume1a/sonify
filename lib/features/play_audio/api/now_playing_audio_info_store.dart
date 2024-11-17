final class NowPlayingAudioInfo {
  NowPlayingAudioInfo({
    required this.audioId,
    required this.playlistId,
    required this.position,
  });

  final String? audioId;
  final String? playlistId;
  final Duration position;

  @override
  String toString() {
    return 'NowPlayingAudioInfo(audioId: $audioId, playlistId: $playlistId, position: $position)';
  }
}

abstract interface class NowPlayingAudioInfoStore {
  Future<void> setNowPlayingAudioInfo(
    NowPlayingAudioInfo nowPlayingAudioInfo,
  );

  Future<NowPlayingAudioInfo?> getNowPlayingAudioInfo();

  Future<void> clearNowPlayingAudioInfo();

  Future<void> setNowPlayingAudioInfoPosition(
    Duration position,
  );
}
