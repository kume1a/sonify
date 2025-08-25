import 'dart:math';

import 'package:flame/components.dart';

import '../flappy_plane_game.dart';

class Background extends Component with HasGameReference<FlappyPlaneGame> {
  late List<BackgroundLayer> layers;
  final List<String> backgroundImages = [
    'background/1.png',
    'background/2.png',
    'background/3.png',
    'background/4.png',
    'background/5.png',
    'background/6.png',
    'background/7.png',
  ];

  @override
  Future<void> onLoad() async {
    layers = [];

    // Create multiple layers with different speeds for parallax effect
    for (int i = 0; i < backgroundImages.length; i++) {
      final layer = BackgroundLayer(
        imagePath: backgroundImages[i],
        speed: 20 + (i * 15), // Different speeds for each layer
        depth: i,
      );
      await add(layer);
      layers.add(layer);
    }
  }
}

class BackgroundLayer extends SpriteComponent with HasGameReference<FlappyPlaneGame> {
  final String imagePath;
  final double speed;
  final int depth;
  late SpriteComponent duplicate;

  BackgroundLayer({required this.imagePath, required this.speed, required this.depth});

  @override
  Future<void> onLoad() async {
    // Load the background sprite
    final image = await game.images.load(imagePath);
    sprite = Sprite(image);

    // Scale to fit the screen height
    final screenSize = game.size;
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();
    final scale = screenSize.y / imageHeight;

    size = Vector2(imageWidth * scale, screenSize.y);
    position = Vector2(0, 0);

    // Create a duplicate for seamless scrolling
    duplicate = SpriteComponent(sprite: sprite, size: size, position: Vector2(size.x, 0));

    await add(duplicate);

    // Set opacity based on depth for layering effect
    opacity = max(0.3, 1.0 - (depth * 0.15));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState == GameState.playing) {
      // Move both sprites to the left
      position.x -= speed * dt;
      duplicate.position.x -= speed * dt;

      // Reset position when sprite goes off screen for seamless loop
      if (position.x <= -size.x) {
        position.x = duplicate.position.x + size.x;
      }

      if (duplicate.position.x <= -size.x) {
        duplicate.position.x = position.x + size.x;
      }
    }
  }
}
