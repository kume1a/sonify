import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'now_playing_audio_info_store.dart';

@LazySingleton(as: NowPlayingAudioInfoStore)
class SharedprefsNowPlayingAudioInfoStore implements NowPlayingAudioInfoStore {
  SharedprefsNowPlayingAudioInfoStore(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  static const _keyAudioId = 'now_playing_audio_info_audio_id';
  static const _keyPlaylistId = 'now_playing_audio_info_playlist_id';
  static const _keyPositionMillis = 'now_playing_audio_info_position_millis';
  static const _isSet = 'now_playing_audio_info_is_set';

  @override
  Future<void> setNowPlayingAudioInfo(
    NowPlayingAudioInfo nowPlayingAudioInfo,
  ) {
    return Future.wait([
      _sharedPreferences.setBool(_isSet, true),
      if (nowPlayingAudioInfo.audioId != null)
        _sharedPreferences.setString(_keyAudioId, nowPlayingAudioInfo.audioId!)
      else
        _sharedPreferences.remove(_keyAudioId),
      if (nowPlayingAudioInfo.playlistId != null)
        _sharedPreferences.setString(_keyPlaylistId, nowPlayingAudioInfo.playlistId!)
      else
        _sharedPreferences.remove(_keyPlaylistId),
      _sharedPreferences.setInt(_keyPositionMillis, nowPlayingAudioInfo.position.inMilliseconds),
    ]);
  }

  @override
  Future<NowPlayingAudioInfo?> getNowPlayingAudioInfo() {
    final isSet = _sharedPreferences.getBool(_isSet);
    if (isSet == null || !isSet) {
      return Future.value();
    }

    final audioId = _sharedPreferences.getString(_keyAudioId);
    final playlistId = _sharedPreferences.getString(_keyPlaylistId);
    final positionMillis = _sharedPreferences.getInt(_keyPositionMillis);

    return Future.value(NowPlayingAudioInfo(
      audioId: audioId,
      playlistId: playlistId,
      position: Duration(milliseconds: positionMillis ?? 0),
    ));
  }

  @override
  Future<void> clearNowPlayingAudioInfo() {
    return Future.wait([
      _sharedPreferences.setBool(_isSet, false),
      _sharedPreferences.remove(_keyAudioId),
      _sharedPreferences.remove(_keyPlaylistId),
      _sharedPreferences.remove(_keyPositionMillis),
    ]);
  }

  @override
  Future<void> setNowPlayingAudioInfoPosition(Duration position) {
    final isSet = _sharedPreferences.getBool(_isSet);
    if (isSet == null || !isSet) {
      return Future.value();
    }

    return _sharedPreferences.setInt(_keyPositionMillis, position.inMilliseconds);
  }
}
