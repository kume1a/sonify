import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_progress_state.freezed.dart';

@freezed
class PlaybackProgressState with _$PlaybackProgressState {
  const factory PlaybackProgressState({
    required Duration current,
    required Duration buffered,
    required Duration total,
  }) = _PlaybackProgressState;

  factory PlaybackProgressState.zero() => const PlaybackProgressState(
        current: Duration.zero,
        buffered: Duration.zero,
        total: Duration.zero,
      );
}
