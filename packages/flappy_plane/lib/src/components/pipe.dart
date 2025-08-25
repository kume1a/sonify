import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_plane_game.dart';

class Pipe extends SpriteComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  final bool isTop;
  final double speed = 100;
  bool hasScored = false;

  Pipe({required Vector2 position, required Vector2 size, required this.isTop})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the tower sprite using relative path (prefix is set in the game)
    final sprite = await game.images.load('tower.png');

    this.sprite = Sprite(sprite);

    // Flip the sprite if it's a top pipe
    if (isTop) {
      scale.y = -1;
    }

    // Add collision detection
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing) {
      // Move pipe to the left
      position.x -= speed * dt;

      // Remove pipe when it goes off screen
      if (position.x + size.x < 0) {
        removeFromParent();
      }

      // Increase score when bird passes through the gap
      if (!hasScored && position.x + size.x < game.bird.position.x) {
        hasScored = true;
        if (!isTop) {
          // Only count once per pipe pair
          game.increaseScore();
        }
      }
    }
  }
}
