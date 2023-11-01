import 'dart:async';
import 'dart:ui';

final class Debounce {
  Debounce(this._duration);

  factory Debounce.fromMilliseconds(int milliseconds) {
    return Debounce(Duration(milliseconds: milliseconds));
  }

  final Duration _duration;

  Timer? _timer;

  void execute(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_duration, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
