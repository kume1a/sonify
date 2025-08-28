import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_plane_game.dart';

class Pipe extends SpriteComponent with HasGameReference<FlappyPlaneGame>, CollisionCallbacks {
  final bool isTop;
  final double speed = 100;
  bool hasScored = false;
  int pipeId = 0;

  Pipe({required Vector2 position, required Vector2 size, required this.isTop})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final sprite = await game.images.load('tower.png');

    this.sprite = Sprite(sprite);

    if (isTop) {
      scale.y = -1;
      position.y += size.y;
    }

    final hitboxSize = Vector2(size.x * 0.8, size.y);
    add(RectangleHitbox(size: hitboxSize, position: Vector2(size.x * 0.1, 0)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing) {
      position.x -= speed * dt;

      if (position.x + size.x < 0) {
        removeFromParent();
      }

      final birdCenterX = game.bird.position.x + (game.bird.size.x / 2);
      final pipeRight = position.x + size.x;

      if (!hasScored && pipeRight < birdCenterX) {
        hasScored = true;
        if (!isTop) {
          game.increaseScore();
        }
      }
    }
  }
}
