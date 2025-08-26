import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_plane_game.dart';

class Pipe extends SpriteComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  final bool isTop;
  final double speed = 100;
  bool hasScored = false;
  int pipeId = 0; // Identifier for pipe pairs

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

    // Add collision detection with more accurate hitbox
    final hitboxSize = Vector2(size.x * 0.8, size.y); // Slightly smaller hitbox for fairness
    add(RectangleHitbox(size: hitboxSize, position: Vector2(size.x * 0.1, 0)));
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
      // Use the center of the bird instead of just position.x for more accurate scoring
      final birdCenterX = game.bird.position.x + (game.bird.size.x / 2);
      final pipeRight = position.x + size.x;

      if (!hasScored && pipeRight < birdCenterX) {
        hasScored = true;
        if (!isTop) {
          // Only count once per pipe pair - use bottom pipe
          print('Bird passed pipe! Bird center: $birdCenterX, Pipe right: $pipeRight');
          game.increaseScore();
        }
      }
    }
  }
}
