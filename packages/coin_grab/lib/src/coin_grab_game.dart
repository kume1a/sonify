import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/background.dart';
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
  double currentSpawnInterval = 2.0;
  double difficultyTimer = 0.0;
  GameState gameState = GameState.intro;

  static const double minSpawnInterval = 0.3;
  static const double difficultyIncreaseInterval = 10.0;

  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = Assets.imagePrefix;
    await images.loadAll(Assets.allImages);

    FlameAudio.audioCache.prefix = Assets.soundPrefix;

    itemSpriteSheet = SpriteSheet(
      image: await images.load(Assets.itemSpritesheet),
      srcSize: Vector2(128, 128),
    );

    final skyBackground = SkyBackground(gameSize: size);
    await add(skyBackground);

    final brickSprite = itemSpriteSheet.getSprite(0, 0);
    final brickGround = BrickGround(brickSprite: brickSprite, gameSize: size);
    await add(brickGround);

    player = Player(
      position: Vector2(size.x / 2, size.y - BrickGround.groundHeight - Player.playerHeight / 2 + 10),
    );
    player.setGameWidth(size.x);
    await add(player);

    showIntro();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState != GameState.playing) return;

    spawnTimer += dt;
    if (spawnTimer >= currentSpawnInterval) {
      _spawnRandomItem();
      spawnTimer = 0.0;
    }

    difficultyTimer += dt;
    if (difficultyTimer >= difficultyIncreaseInterval) {
      _increaseDifficulty();
      difficultyTimer = 0.0;
    }
  }

  void _spawnRandomItem() {
    final x = random.nextDouble() * (size.x - 64);
    final position = Vector2(x, -64);

    CollectibleItem item;
    final itemType = random.nextInt(100);

    if (itemType < 50) {
      item = GoldCoin(sprite: itemSpriteSheet.getSprite(0, 1), position: position);
    } else if (itemType < 75) {
      item = DollarBill(sprite: itemSpriteSheet.getSprite(1, 1), position: position);
    } else if (itemType < 90) {
      item = GoldBar(sprite: itemSpriteSheet.getSprite(0, 2), position: position);
    } else {
      item = Bacon(sprite: itemSpriteSheet.getSprite(1, 0), position: position);
    }

    add(item);
  }

  void _increaseDifficulty() {
    if (currentSpawnInterval > minSpawnInterval) {
      currentSpawnInterval = (currentSpawnInterval - 0.1).clamp(minSpawnInterval, double.infinity);
    }
  }

  double? _lastDragX;

  void handleDragStart(double dragX) {
    _lastDragX = dragX;
  }

  void handleDragUpdate(double currentDragX) {
    if (gameState == GameState.gameOver || _lastDragX == null) return;

    final dragDelta = currentDragX - _lastDragX!;
    final dragSpeed = dragDelta.abs();

    final newPlayerX = (player.position.x + dragDelta).clamp(player.size.x / 2, size.x - player.size.x / 2);
    player.position.x = newPlayerX;

    final isRunning = dragSpeed > 2.0;

    if (dragDelta > 0.1) {
      player.setMovingRight(isRunning: isRunning);
    } else if (dragDelta < -0.1) {
      player.setMovingLeft(isRunning: isRunning);
    } else {
      player.setIdle();
    }

    _lastDragX = currentDragX;
  }

  void handleDragEnd() {
    _lastDragX = null;
    player.setIdle();
  }

  void onItemCollected(CollectibleItem item) {
    if (item is Bacon) {
      gameOver();
      return;
    }

    score += item.points;
    player.celebrate();
    item.onCollected();

    overlays.remove('Score');
    Future.microtask(() => overlays.add('Score'));
  }

  void onItemMissed() {}

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

    score = 0;
    spawnTimer = 0.0;
    currentSpawnInterval = 2.0;
    difficultyTimer = 0.0;

    removeWhere((component) => component is CollectibleItem);

    player.position.x = size.x / 2;
    player.setIdle();

    FlameAudio.bgm.play(Assets.havaNagilaMusic, volume: 0.5);
  }

  void gameOver() {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;
    overlays.remove('Score');
    overlays.add('GameOver');

    FlameAudio.bgm.stop();
  }

  void resetGame() {
    gameState = GameState.mainMenu;
    overlays.remove('GameOver');

    removeWhere((component) => component is CollectibleItem);

    showMainMenu();
  }

  void handleTap() {
    switch (gameState) {
      case GameState.intro:
        showMainMenu();
      case GameState.mainMenu:
        startGame();
      case GameState.gameOver:
        resetGame();
      case GameState.playing:
        break;
    }
  }
}
