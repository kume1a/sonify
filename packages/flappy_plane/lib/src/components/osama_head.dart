import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class OsamaHead extends SpriteComponent with HasGameReference {
  static const double _fadeDuration = 1.0; // Duration for fade in/out in seconds
  static const double _displayDuration = 2.0; // Duration to display the head

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
        // Fade in complete, start display timer
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
        // Fade out complete, hide the component
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

    // Update opacity based on current state and timer progress
    if (_fadeTimer != null && _fadeTimer!.isRunning()) {
      double progress = _fadeTimer!.progress;

      if (_isFadingOut) {
        // Fade out
        opacity = 1.0 - progress;
      } else {
        // Fade in
        opacity = progress;
      }
    } else if (_displayTimer != null && _displayTimer!.isRunning()) {
      // Fully visible during display period
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
