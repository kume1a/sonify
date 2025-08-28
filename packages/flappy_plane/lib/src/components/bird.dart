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

  // Crash physics
  bool isCrashed = false;
  double angularVelocity = 0; // For rotation during fall
  final double crashGravity = 1200; // Stronger gravity when crashed
  final double maxCrashVelocity = 600; // Higher max velocity when falling

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

    // Reset crash state
    isCrashed = false;
    angularVelocity = 0;
  }

  void flap() {
    // Don't allow flapping when crashed
    if (isCrashed) return;

    velocity = jumpForce;
    timeSinceLastFlap = 0.0; // Reset the timer when flapping

    // Add a smoother rotation animation for visual effect
    add(RotateEffect.to(-0.2, EffectController(duration: 0.15, curve: Curves.easeOutCubic)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing && !isCrashed) {
      // Normal flight physics
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
    } else if (isCrashed) {
      // Crash physics - plane falls and rotates
      velocity += crashGravity * dt;
      velocity = velocity.clamp(-maxCrashVelocity, maxCrashVelocity);

      // Update position
      position.y += velocity * dt;

      // Add angular velocity for tipping over (clockwise rotation)
      angularVelocity += 3.0 * dt; // Increase rotation speed over time
      angle += angularVelocity * dt;

      // Stop falling when hitting the ground
      if (position.y > game.size.y - size.y) {
        position.y = game.size.y - size.y;
        velocity = 0;
        angularVelocity *= 0.8; // Slow down rotation on ground
      }
    }
  }

  @override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe && !isCrashed) {
      // Calculate explosion point at the tip/nose of the plane
      // Since the plane is flipped horizontally (scale.x = -1), the nose is at the left edge
      final explosionPoint = Vector2(
        position.x + size.x * 0.1, // Near the nose (left edge due to flip)
        position.y + size.y / 2, // Center vertically
      );

      // Set crashed state and initial rotation
      isCrashed = true;
      angularVelocity = 2.0; // Initial rotation speed

      game.gameOver(explosionPoint);
      return true;
    }
    return false;
  }
}
