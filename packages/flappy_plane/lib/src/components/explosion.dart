import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class Explosion extends SpriteAnimationComponent with HasGameReference {
  static const int frameCount = 12; // Number of frames in the explosion atlas
  static const double frameDuration = 0.1; // Duration per frame in seconds

  bool _hasPlayed = false;
  Timer? _removalTimer;
  final VoidCallback? onComplete;

  Explosion({required Vector2 position, this.onComplete}) : super(position: position);

  @override
  Future<void> onLoad() async {
    // Load the explosion atlas
    final image = await game.images.load('explosion_atlas.png');

    // Calculate frame dimensions (assuming horizontal strip layout)
    final frameWidth = image.width / frameCount;
    final frameHeight = image.height.toDouble();

    // Create sprites for each frame
    final List<Sprite> sprites = [];
    for (int i = 0; i < frameCount; i++) {
      sprites.add(
        Sprite(image, srcPosition: Vector2(i * frameWidth, 0), srcSize: Vector2(frameWidth, frameHeight)),
      );
    }

    // Create the animation
    animation = SpriteAnimation.spriteList(sprites, stepTime: frameDuration, loop: false);

    // Set size (adjust as needed)
    size = Vector2(120, 120);

    // Center the explosion on the collision point
    anchor = Anchor.center;

    // Play explosion sound with lower volume
    if (!_hasPlayed) {
      FlameAudio.play('explosion.mp3', volume: 0.3);
      _hasPlayed = true;
    }

    // Set up removal timer
    _removalTimer = Timer(
      frameCount * frameDuration + 0.1, // Add small buffer
      onTick: () {
        onComplete?.call(); // Call completion callback before removal
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
