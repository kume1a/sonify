import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../flappy_plane_game.dart';
import 'pipe.dart';

class Bird extends SpriteAnimationComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = 860; // Slightly reduced gravity for smoother gameplay
  final double jumpForce = -350;
  final double maxVelocity = 300;
  double timeSinceLastFlap = 0.0;
  final double autoFallDelay = 0.3; // Time in seconds before auto-falling starts

  @override
  Future<void> onLoad() async {
    // Load the plane sprite using relative path (prefix is set in the game)
    final sprite = await game.images.load('plane.png');

    // Create a simple animation by using the same sprite, flipped to face right
    final spriteAnimation = SpriteAnimation.spriteList([Sprite(sprite)], stepTime: 0.2);

    animation = spriteAnimation;
    size = Vector2(100, 40);

    // Flip the sprite horizontally to make it face right
    scale.x = -1;

    // Add collision detection with smaller hitbox for better accuracy
    add(RectangleHitbox(size: Vector2(100, 40)));

    // Position the bird
    reset();
  }

  void reset() {
    // Position the bird slightly left of center (30% from left instead of 20%)
    position = Vector2(game.size.x * 0.35, game.size.y * 0.5);
    velocity = 0;
    angle = 0;
    timeSinceLastFlap = 0.0;
  }

  void flap() {
    velocity = jumpForce;
    timeSinceLastFlap = 0.0; // Reset the timer when flapping

    // Add a smoother rotation animation for visual effect
    add(RotateEffect.to(-0.2, EffectController(duration: 0.15, curve: Curves.easeOutCubic)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing) {
      // Update time since last flap
      timeSinceLastFlap += dt;

      // Apply gravity - stronger gravity after the auto-fall delay
      double currentGravity = gravity;
      if (timeSinceLastFlap > autoFallDelay) {
        // Increase gravity slightly after no flap for a while (Flappy Bird behavior)
        currentGravity = gravity * 1.2;
      }

      velocity += currentGravity * dt;

      // Limit velocity
      velocity = velocity.clamp(-maxVelocity, maxVelocity);

      // Update position
      position.y += velocity * dt;

      // Rotate based on velocity for visual effect - smoother rotation
      final targetAngle = (velocity / maxVelocity) * 0.4; // Reduced rotation amount
      angle += (targetAngle - angle) * dt * 8; // Smooth interpolation
    }
  }

  @override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe) {
      game.gameOver();
      return true;
    }
    return false;
  }
}
