import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SkyBackground extends PositionComponent {
  SkyBackground({required Vector2 gameSize})
    : super(size: gameSize, position: Vector2.zero(), priority: -100);

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..shader = ui.Gradient.linear(Offset(0, 0), Offset(0, size.y), [
        const Color(0xFF62cff4),
        const Color(0xFF2c67f2),
      ]);

    canvas.drawRect(size.toRect(), paint);
  }
}

class BrickGround extends PositionComponent {
  final Sprite brickSprite;
  static const double brickSize = 128.0;
  static const int groundRows = 1;
  static const double groundHeight = brickSize * groundRows;

  BrickGround({required this.brickSprite, required Vector2 gameSize})
    : super(
        size: Vector2(gameSize.x, groundHeight),
        position: Vector2(0, gameSize.y - groundHeight),
        priority: -50,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final int tilesNeeded = (size.x / brickSize).ceil() + 1;

    for (int col = 0; col < tilesNeeded; col++) {
      final tile = SpriteComponent(
        sprite: brickSprite,
        size: Vector2(brickSize, brickSize),
        position: Vector2(col * brickSize, 0),
      );
      await add(tile);
    }
  }
}
