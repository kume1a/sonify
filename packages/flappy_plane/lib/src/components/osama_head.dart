import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class OsamaHead extends SpriteComponent with HasGameReference {
  static const double _fadeDuration = 1.0;
  static const double _displayDuration = 2.0;

  bool _isVisible = false;
  Timer? _fadeTimer;
  Timer? _displayTimer;
  bool _isFadingOut = false;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('osama_head.png');

    size = Vector2(200, 200);
    position = Vector2((game.size.x - size.x) / 2, (game.size.y - size.y) / 3);

    opacity = 0.0;
  }

  void show() {
    if (_isVisible) return;

    _isVisible = true;

    FlameAudio.play('alahuakbar.mp3');

    _fadeIn();
  }

  void _fadeIn() {
    _fadeTimer?.stop();
    _isFadingOut = false;

    _fadeTimer = Timer(
      _fadeDuration,
      onTick: () {
        _displayTimer = Timer(
          _displayDuration,
          onTick: () {
            _fadeOut();
          },
        );
        _displayTimer!.start();
      },
    );

    _fadeTimer!.start();
  }

  void _fadeOut() {
    _fadeTimer?.stop();
    _isFadingOut = true;

    _fadeTimer = Timer(
      _fadeDuration,
      onTick: () {
        _isVisible = false;
        opacity = 0.0;
        removeFromParent();
      },
    );

    _fadeTimer!.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _fadeTimer?.update(dt);
    _displayTimer?.update(dt);

    if (_fadeTimer != null && _fadeTimer!.isRunning()) {
      double progress = _fadeTimer!.progress;

      if (_isFadingOut) {
        opacity = 1.0 - progress;
      } else {
        opacity = progress;
      }
    } else if (_displayTimer != null && _displayTimer!.isRunning()) {
      opacity = 1.0;
    }
  }

  @override
  void onRemove() {
    _fadeTimer?.stop();
    _displayTimer?.stop();
    super.onRemove();
  }
}
