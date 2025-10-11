import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';
import 'player.dart';

abstract class CollectibleItem extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CoinGrabGame> {
  final int points;
  final double fallSpeed;
  final String itemType;
  bool _isCollected = false; // Prevent duplicate collision processing

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

    // Add a generous hitbox for reliable collision detection
    // Use 90% of sprite size, centered
    final hitbox = RectangleHitbox(size: size * 0.9, position: size * 0.05);

    // Enable debug mode to show hitbox outline
    hitbox.debugMode = true;
    await add(hitbox);

    print('Item hitbox loaded: type=$itemType, size=${hitbox.size}, position=${hitbox.position}');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Skip processing if already collected
    if (_isCollected) return;

    // Make the item fall
    position.y += fallSpeed * dt;

    // Remove item if it falls off screen
    final game = findGame();
    if (game != null && position.y > game.size.y) {
      // Only count as missed if not already collected
      if (game is CoinGrabGame && !_isCollected) {
        _isCollected = true; // Mark as processed to prevent duplicate miss counting
        game.onItemMissed();
      }
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Handle collision with player
    if (other is Player && !_isCollected) {
      _isCollected = true; // Mark as collected immediately to prevent duplicate processing
      print('✓ COLLISION DETECTED! Item: $itemType, Points: $points');

      final game = findGame();
      if (game is CoinGrabGame) {
        print('✓ Calling game.onItemCollected()');
        game.onItemCollected(this);
      } else {
        print('✗ Game not found or not CoinGrabGame');
      }
    }
  }

  /// Called when this item is collected
  void onCollected();
}
