import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'components/collectible_item.dart';
import 'components/items.dart';
import 'components/player.dart';
import 'constants/assets.dart';

enum GameState { intro, mainMenu, playing, gameOver }

class CoinGrabGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late SpriteSheet itemSpriteSheet;

  int score = 0;
  double spawnTimer = 0.0;
  double currentSpawnInterval = 2.0; // Start spawning every 2 seconds
  double difficultyTimer = 0.0;
  GameState gameState = GameState.intro;

  // Game over conditions
  int missedItems = 0;
  static const int maxMissedItems = 10; // Game over after missing 10 items

  // Game balance
  static const double minSpawnInterval = 0.3;
  static const double difficultyIncreaseInterval = 10.0; // Increase difficulty every 10 seconds

  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = Assets.imagePrefix;

    await images.loadAll(Assets.allImages);

    itemSpriteSheet = SpriteSheet(image: await images.load(Assets.itemSpritesheet), srcSize: Vector2(64, 64));

    player = Player(
      // Position is at center due to Anchor.center
      position: Vector2(size.x / 2, size.y - Player.playerHeight / 2 - 20),
    );
    player.setGameWidth(size.x);
    await add(player);

    showIntro();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Only spawn items and run difficulty timer when playing
    if (gameState != GameState.playing) return;

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
  double? _lastDragX;

  void handleDragStart(double dragX) {
    _lastDragX = dragX;
  }

  void handleDragUpdate(double currentDragX) {
    // Prevent drag movement during game over
    if (gameState == GameState.gameOver) return;

    if (_lastDragX != null) {
      // Calculate movement since last frame (instant direction detection)
      final dragDelta = currentDragX - _lastDragX!;
      final dragSpeed = dragDelta.abs();

      // Move the player by the delta amount, keeping within bounds (accounting for centered anchor)
      final newPlayerX = (player.position.x + dragDelta).clamp(player.size.x / 2, size.x - player.size.x / 2);
      player.position.x = newPlayerX;

      // Update animation based on movement direction and speed
      // Use running animation for fast drags (greater than 2.0 pixels per frame)
      final isRunning = dragSpeed > 2.0;

      // Immediate direction detection - flip as soon as direction changes
      if (dragDelta > 0.1) {
        player.setMovingRight(isRunning: isRunning);
      } else if (dragDelta < -0.1) {
        player.setMovingLeft(isRunning: isRunning);
      } else {
        player.setIdle();
      }

      // Update last position for next frame
      _lastDragX = currentDragX;
    }
  }

  void handleDragEnd() {
    _lastDragX = null;
    player.setIdle();
  }

  /// Called when player collects an item
  void onItemCollected(CollectibleItem item) {
    score += item.points;
    print('Item collected! Type: ${item.itemType}, Points: ${item.points}, Total Score: $score');
    player.celebrate();
    item.onCollected();

    // Force overlay refresh by removing and re-adding with a short delay
    overlays.remove('Score');
    Future.microtask(() => overlays.add('Score'));
  }

  /// Called when an item is missed (falls off screen)
  void onItemMissed() {
    if (gameState != GameState.playing) return;

    missedItems++;
    print('Item missed! Total missed: $missedItems / $maxMissedItems');

    // Update score overlay to reflect missed count change
    overlays.remove('Score');
    Future.microtask(() => overlays.add('Score'));

    if (missedItems >= maxMissedItems) {
      gameOver();
    }
  }

  // Game state management methods
  void showIntro() {
    gameState = GameState.intro;
    overlays.add('Intro');
  }

  void showMainMenu() {
    gameState = GameState.mainMenu;
    overlays.remove('Intro');
    overlays.add('MainMenu');
  }

  void startGame() {
    gameState = GameState.playing;
    overlays.remove('MainMenu');
    overlays.add('Score');

    // Reset game state
    score = 0;
    missedItems = 0;
    spawnTimer = 0.0;
    currentSpawnInterval = 2.0;
    difficultyTimer = 0.0;

    // Clear any existing items
    removeWhere((component) => component is CollectibleItem);

    // Reset player position (centered due to Anchor.center)
    player.position.x = size.x / 2;
    player.setIdle();
  }

  void gameOver() {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;
    overlays.remove('Score');
    overlays.add('GameOver');
  }

  void resetGame() {
    gameState = GameState.mainMenu;
    overlays.remove('GameOver');

    // Clear all items
    removeWhere((component) => component is CollectibleItem);

    showMainMenu();
  }

  void handleTap() {
    switch (gameState) {
      case GameState.intro:
        showMainMenu();
        break;
      case GameState.mainMenu:
        startGame();
        break;
      case GameState.gameOver:
        resetGame();
        break;
      case GameState.playing:
        // No tap handling during gameplay for coin grab
        break;
    }
  }
}
