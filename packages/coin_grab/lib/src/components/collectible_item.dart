import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';
import 'background.dart';
import 'player.dart';

abstract class CollectibleItem extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CoinGrabGame> {
  final int points;
  final double fallSpeed;
  final String itemType;
  bool _isCollected = false;

  CollectibleItem({
    required this.points,
    required this.fallSpeed,
    required this.itemType,
    required Sprite sprite,
    required Vector2 size,
    Vector2? position,
  }) : super(sprite: sprite, size: size, position: position ?? Vector2.zero());

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final hitbox = RectangleHitbox(size: size * 0.9, position: size * 0.05);
    hitbox.debugMode = false;
    await add(hitbox);
  }

  @override
  void render(ui.Canvas canvas) {
    final game = findGame();
    if (game != null) {
      final groundLevel = game.size.y - BrickGround.groundHeight;

      if (position.y + size.y > groundLevel) {
        final visibleHeight = groundLevel - position.y;

        if (visibleHeight > 0) {
          canvas.save();
          canvas.clipRect(ui.Rect.fromLTWH(0, 0, size.x, visibleHeight));
          super.render(canvas);
          canvas.restore();
        }
      } else {
        super.render(canvas);
      }
    } else {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isCollected) return;

    position.y += fallSpeed * dt;

    final game = findGame();
    if (game != null) {
      final groundLevel = game.size.y - BrickGround.groundHeight;
      if (position.y >= groundLevel + size.y) {
        if (game is CoinGrabGame && !_isCollected) {
          _isCollected = true;
          game.onItemMissed();
        }
        removeFromParent();
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player && !_isCollected) {
      _isCollected = true;

      final game = findGame();
      if (game is CoinGrabGame) {
        game.onItemCollected(this);
      }
    }
  }

  void onCollected();
}
