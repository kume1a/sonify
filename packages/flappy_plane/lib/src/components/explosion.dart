import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';

class Explosion extends SpriteAnimationComponent with HasGameReference {
  static const int frameCount = 12;
  static const double frameDuration = 0.1;

  bool _hasPlayed = false;
  Timer? _removalTimer;
  final VoidCallback? onComplete;

  Explosion({required Vector2 position, this.onComplete}) : super(position: position);

  @override
  Future<void> onLoad() async {
    final image = await game.images.load(FlappyPlaneAssets.explosionAtlasPng);

    final frameWidth = image.width / frameCount;
    final frameHeight = image.height.toDouble();

    final List<Sprite> sprites = [];
    for (int i = 0; i < frameCount; i++) {
      sprites.add(
        Sprite(image, srcPosition: Vector2(i * frameWidth, 0), srcSize: Vector2(frameWidth, frameHeight)),
      );
    }

    animation = SpriteAnimation.spriteList(sprites, stepTime: frameDuration, loop: false);

    size = Vector2(120, 120);

    anchor = Anchor.center;

    if (!_hasPlayed) {
      FlameAudio.play(FlappyPlaneAssets.explosionMp3, volume: 0.3);
      _hasPlayed = true;
    }

    _removalTimer = Timer(
      frameCount * frameDuration + 0.1,
      onTick: () {
        onComplete?.call();
        removeFromParent();
      },
    );
    _removalTimer!.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _removalTimer?.update(dt);
  }

  @override
  void onRemove() {
    _removalTimer?.stop();
    super.onRemove();
  }
}
