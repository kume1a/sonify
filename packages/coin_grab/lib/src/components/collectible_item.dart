import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';

abstract class CollectibleItem extends SpriteComponent with HasCollisionDetection, CollisionCallbacks {
  final int points;
  final double fallSpeed;
  final String itemType;

  CollectibleItem({
    required this.points,
    required this.fallSpeed,
    required this.itemType,
    required Sprite sprite,
    required Vector2 size,
    Vector2? position,
  }) : super(sprite: sprite, size: size, position: position ?? Vector2.zero()) {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Make the item fall
    position.y += fallSpeed * dt;

    // Remove item if it falls off screen
    final game = findGame();
    if (game != null && position.y > game.size.y) {
      // Notify the game that an item was missed
      if (game is CoinGrabGame) {
        game.onItemMissed();
      }
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Handle collision with player
    if (other.runtimeType.toString().contains('Player')) {
      final game = findGame();
      if (game is CoinGrabGame) {
        game.onItemCollected(this);
      }
    }
  }

  /// Called when this item is collected
  void onCollected();
}
