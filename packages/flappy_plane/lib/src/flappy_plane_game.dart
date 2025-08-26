import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'components/pipe.dart';

enum GameState { mainMenu, playing, gameOver }

class FlappyPlaneGame extends FlameGame with HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  Timer interval = Timer(1.5, repeat: true);
  bool isHit = false;
  int score = 0;
  GameState gameState = GameState.mainMenu;

  @override
  Future<void> onLoad() async {
    // Set the correct prefix for package assets - Flame will use this base path
    images.prefix = 'packages/flappy_plane/lib/assets/images/';

    // Load and cache all images with relative paths
    await images.loadAll([
      'plane.png',
      'tower.png',
      'background/1.png',
      'background/2.png',
      'background/3.png',
      'background/4.png',
      'background/5.png',
      'background/6.png',
      'background/7.png',
    ]);

    background = Background();
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    interval.onTick = () => _spawnPipe();

    // Show main menu
    showMainMenu();
  }

  void _spawnPipe() {
    if (gameState != GameState.playing) return;

    final screenHeight = size.y;
    final groundHeight = screenHeight * 0.2;
    final availableHeight = screenHeight - groundHeight;
    final pipeGap = 150.0;

    // Random position for the gap between pipes
    final gapTop = Random().nextDouble() * (availableHeight - pipeGap - 100) + 50;
    final gapBottom = gapTop + pipeGap;

    // Top pipe
    final topPipe = Pipe(position: Vector2(size.x, 0), size: Vector2(50, gapTop), isTop: true);

    // Bottom pipe
    final bottomPipe = Pipe(
      position: Vector2(size.x, gapBottom),
      size: Vector2(50, screenHeight - gapBottom - groundHeight),
      isTop: false,
    );

    add(topPipe);
    add(bottomPipe);
  }

  void handleTap() {
    if (gameState == GameState.mainMenu) {
      startGame();
    } else if (gameState == GameState.playing) {
      bird.flap();
    } else if (gameState == GameState.gameOver) {
      resetGame();
    }
  }

  void startGame() {
    gameState = GameState.playing;
    overlays.remove('MainMenu');
    overlays.add('Score');

    // Reset bird position and velocity
    bird.reset();

    // Start spawning pipes
    interval.start();
  }

  void resetGame() {
    gameState = GameState.mainMenu;
    overlays.remove('GameOver');
    overlays.remove('Score');

    // Remove all pipes
    removeWhere((component) => component is Pipe);

    // Reset score
    score = 0;
    isHit = false;

    // Reset bird
    bird.reset();

    // Stop spawning pipes
    interval.stop();

    // Show main menu
    showMainMenu();
  }

  void showMainMenu() {
    overlays.add('MainMenu');
  }

  void gameOver() {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;
    interval.stop();
    overlays.remove('Score');
    overlays.add('GameOver');
  }

  void increaseScore() {
    score++;
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    // Check if bird hit the ground or went off screen
    if (gameState == GameState.playing) {
      if (bird.position.y > size.y - ground.size.y - bird.size.y || bird.position.y < 0) {
        gameOver();
      }
    }
  }
}
