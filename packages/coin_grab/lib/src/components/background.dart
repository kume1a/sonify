import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Simple blue gradient sky background
class SkyBackground extends PositionComponent {
  SkyBackground({required Vector2 gameSize})
    : super(
        size: gameSize,
        position: Vector2.zero(),
        priority: -100, // Behind everything
      );

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    // Create a darker blue gradient from top to bottom
    final paint = Paint()
      ..shader = ui.Gradient.linear(Offset(0, 0), Offset(0, size.y), [
        const Color(0xFF62cff4), // Darker blue at top
        const Color(0xFF2c67f2), // Even darker blue at bottom
      ]);

    canvas.drawRect(size.toRect(), paint);
  }
}

/// Repeatable brick ground component - creates a tiled ground
class BrickGround extends PositionComponent {
  final Sprite brickSprite;
  static const double brickSize = 128.0; // Original sprite size
  static const int groundRows = 1; // 1 row of bricks
  static const double groundHeight = brickSize * groundRows; // Total height

  BrickGround({required this.brickSprite, required Vector2 gameSize})
    : super(
        size: Vector2(gameSize.x, groundHeight),
        position: Vector2(0, gameSize.y - groundHeight),
        priority: -50, // In front of background, behind player and items
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Calculate how many brick tiles we need to fill the width
    final int tilesNeeded = (size.x / brickSize).ceil() + 1;

    // Create 1 row of brick tiles
    for (int col = 0; col < tilesNeeded; col++) {
      final tile = SpriteComponent(
        sprite: brickSprite,
        size: Vector2(brickSize, brickSize), // Keep original size, no stretching
        position: Vector2(col * brickSize, 0),
      );
      await add(tile);
    }
  }
}
