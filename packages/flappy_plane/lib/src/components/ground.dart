import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../flappy_plane_game.dart';

class Ground extends RectangleComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    final screenSize = game.size;
    final groundHeight = screenSize.y * 0.2;

    size = Vector2(screenSize.x, groundHeight);
    position = Vector2(0, screenSize.y - groundHeight);

    paint = Paint()..color = const Color(0xFF8B4513);

    add(RectangleHitbox());
  }
}
