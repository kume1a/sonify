import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/bird.dart';
import 'components/pipe.dart';

enum GameState { mainMenu, playing, gameOver }

class FlappyPlaneGame extends FlameGame with HasCollisionDetection {
  late Bird bird;
  late Background background;
  Timer interval = Timer(1.8, repeat: true); // Slightly slower spawn rate for better gameplay
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
    ]);

    background = Background();
    add(background);

    bird = Bird();
    add(bird);

    interval.onTick = () => _spawnPipe();

    showMainMenu();
  }

  void _spawnPipe() {
    if (gameState != GameState.playing) return;

    final screenHeight = size.y;
    final pipeGap = 120.0; // Classic Flappy Bird gap size
    final pipeWidth = 80.0;

    // Calculate safe bounds for pipe placement (leave room at top and bottom)
    final safeMargin = 100.0;
    final availableHeight = screenHeight - pipeGap - (2 * safeMargin);

    // Random position for the gap between pipes with safe bounds
    final gapTop = Random().nextDouble() * availableHeight + safeMargin;
    final gapBottom = gapTop + pipeGap;

    // Create pipe pair
    // Top pipe
    final topPipe = Pipe(position: Vector2(size.x, 0), size: Vector2(pipeWidth, gapTop), isTop: true);

    // Bottom pipe
    final bottomPipe = Pipe(
      position: Vector2(size.x, gapBottom),
      size: Vector2(pipeWidth, screenHeight - gapBottom),
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
      resetGame(); // Re-enabled tap-to-restart for game over state
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
    print('Score increased to: $score'); // Debug print

    // Force overlay update by removing and re-adding it
    overlays.remove('Score');
    overlays.add('Score');
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    // Check if bird hit the bottom or went off screen top
    if (gameState == GameState.playing) {
      if (bird.position.y > size.y - bird.size.y || bird.position.y < 0) {
        gameOver();
      }
    }
  }
}
