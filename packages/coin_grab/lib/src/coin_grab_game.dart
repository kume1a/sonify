import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' show Color, TextStyle, FontWeight;

import 'components/collectible_item.dart';
import 'components/items.dart';
import 'components/player.dart';
import 'constants/assets.dart';

/// Main game world that manages all game logic
class CoinGrabGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late TextComponent scoreText;
  late SpriteSheet itemSpriteSheet;

  int score = 0;
  double spawnTimer = 0.0;
  double currentSpawnInterval = 2.0; // Start spawning every 2 seconds
  double difficultyTimer = 0.0;

  // Game balance
  static const double minSpawnInterval = 0.3;
  static const double difficultyIncreaseInterval = 10.0; // Increase difficulty every 10 seconds

  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set asset prefixes like flappy plane
    images.prefix = CoinGrabAssets.imagePrefix;

    // Load all images
    await images.loadAll(CoinGrabAssets.allImages);

    // Load item spritesheet
    itemSpriteSheet = SpriteSheet(
      image: await images.load(CoinGrabAssets.itemSpritesPng),
      srcSize: Vector2(64, 64),
    );

    // Initialize player at bottom center
    player = Player(
      position: Vector2(size.x / 2 - Player.playerWidth / 2, size.y - Player.playerHeight - 20),
    );
    player.setGameWidth(size.x);
    add(player);

    // Initialize score display
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle item spawning
    spawnTimer += dt;
    if (spawnTimer >= currentSpawnInterval) {
      _spawnRandomItem();
      spawnTimer = 0.0;
    }

    // Increase difficulty over time
    difficultyTimer += dt;
    if (difficultyTimer >= difficultyIncreaseInterval) {
      _increaseDifficulty();
      difficultyTimer = 0.0;
    }
  }

  void _spawnRandomItem() {
    final x = random.nextDouble() * (size.x - 64); // Random x position
    final position = Vector2(x, -64); // Start above screen

    CollectibleItem item;
    final itemType = random.nextInt(10); // 0-9 for different probabilities

    if (itemType < 7) {
      // 70% chance for coins
      item = Coin(
        sprite: itemSpriteSheet.getSprite(0, 0), // First coin sprite
        position: position,
      );
    } else if (itemType < 9) {
      // 20% chance for gems
      item = Gem(
        sprite: itemSpriteSheet.getSprite(4, 0), // Gem sprite
        position: position,
      );
    } else {
      // 10% chance for money bags
      item = MoneyBag(
        sprite: itemSpriteSheet.getSprite(8, 0), // Money bag sprite
        position: position,
      );
    }

    add(item);
  }

  void _increaseDifficulty() {
    if (currentSpawnInterval > minSpawnInterval) {
      currentSpawnInterval -= 0.1;
      if (currentSpawnInterval < minSpawnInterval) {
        currentSpawnInterval = minSpawnInterval;
      }
    }
  }

  /// Handle drag input for player movement
  double? _dragStartX;
  double? _initialPlayerX;

  void handleDragStart(double dragX) {
    _dragStartX = dragX;
    _initialPlayerX = player.position.x;
  }

  void handleDragUpdate(double currentDragX) {
    if (_dragStartX != null && _initialPlayerX != null) {
      // Calculate how much the finger has moved horizontally
      final dragDelta = currentDragX - _dragStartX!;

      // Move the player by the same amount, keeping within bounds
      final newPlayerX = (_initialPlayerX! + dragDelta).clamp(0.0, size.x - player.size.x);
      player.position.x = newPlayerX;

      // Update animation based on movement direction
      if (dragDelta > 2.0) {
        player.setMovingRight();
      } else if (dragDelta < -2.0) {
        player.setMovingLeft();
      } else {
        player.setIdle();
      }
    }
  }

  void handleDragEnd() {
    _dragStartX = null;
    _initialPlayerX = null;
    player.setIdle();
  }

  /// Called when player collects an item
  void onItemCollected(CollectibleItem item) {
    score += item.points;
    scoreText.text = 'Score: $score';
    player.celebrate();
    item.onCollected();
  }
}
