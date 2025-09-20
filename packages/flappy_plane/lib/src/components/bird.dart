import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../flappy_plane_game.dart';
import 'pipe.dart';

class Bird extends SpriteAnimationComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = 860;
  final double jumpForce = -350;
  final double maxVelocity = 300;
  double timeSinceLastFlap = 0.0;
  final double autoFallDelay = 0.3;

  bool isCrashed = false;
  double angularVelocity = 0;
  final double crashGravity = 1200;
  final double maxCrashVelocity = 600;

  @override
  Future<void> onLoad() async {
    final sprite = await game.images.load(Assets.planePng);

    final spriteAnimation = SpriteAnimation.spriteList([Sprite(sprite)], stepTime: 0.2);

    animation = spriteAnimation;
    size = Vector2(100, 40);

    scale.x = -1;

    add(RectangleHitbox(size: Vector2(100, 40)));

    reset();
  }

  void reset() {
    position = Vector2(game.size.x * 0.35, game.size.y * 0.5);
    velocity = 0;
    angle = 0;
    timeSinceLastFlap = 0.0;

    isCrashed = false;
    angularVelocity = 0;
  }

  void flap() {
    if (isCrashed) return;

    velocity = jumpForce;
    timeSinceLastFlap = 0.0;

    add(RotateEffect.to(-0.2, EffectController(duration: 0.15, curve: Curves.easeOutCubic)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing && !isCrashed) {
      timeSinceLastFlap += dt;

      double currentGravity = gravity;
      if (timeSinceLastFlap > autoFallDelay) {
        currentGravity = gravity * 1.2;
      }

      velocity += currentGravity * dt;

      velocity = velocity.clamp(-maxVelocity, maxVelocity);

      position.y += velocity * dt;

      final targetAngle = (velocity / maxVelocity) * 0.4;
      angle += (targetAngle - angle) * dt * 8;
    } else if (isCrashed) {
      // Check if the plane has hit the ground
      final groundY = game.size.y - size.y;

      if (position.y < groundY) {
        // Still falling
        velocity += crashGravity * dt;
        velocity = velocity.clamp(-maxCrashVelocity, maxCrashVelocity);
        position.y += velocity * dt;

        angularVelocity += 3.0 * dt;
        angle += angularVelocity * dt;
      } else {
        // Hit the ground, stop all movement
        position.y = groundY;
        velocity = 0;
        angularVelocity = 0;
        // Keep the final rotation angle, don't reset it
      }
    }
  }

  @override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe && !isCrashed) {
      final explosionPoint = Vector2(position.x + size.x * 0.1, position.y + size.y / 2);

      isCrashed = true;
      angularVelocity = 2.0;

      // Move the bird to the front so it renders on top of pipes
      game.bringBirdToFront();

      game.gameOver(explosionPoint);
      return true;
    }
    return false;
  }
}
