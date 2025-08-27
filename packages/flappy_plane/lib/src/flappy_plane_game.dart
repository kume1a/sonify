import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/bird.dart';
import 'components/pipe.dart';

enum GameState { intro, mainMenu, playing, gameOver }

class FlappyPlaneGame extends FlameGame with HasCollisionDetection {
  late Bird bird;
  late Background background;
  Timer interval = Timer(2.0, repeat: true);
  bool isHit = false;
  int score = 0;
  GameState gameState = GameState.intro;

  @override
  Future<void> onLoad() async {
    images.prefix = 'packages/flappy_plane/lib/assets/images/';

    await images.loadAll([
      'plane.png',
      'tower.png',
      'osama.png',
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

    showIntro();
  }

  void _spawnPipe() {
    if (gameState != GameState.playing) return;

    final screenHeight = size.y;
    final pipeGap = 220.0;
    final pipeWidth = 80.0;

    // Calculate safe bounds for pipe placement (leave room at top and bottom)
    final safeMargin = 100.0;
    final availableHeight = screenHeight - pipeGap - (2 * safeMargin);

    // Random position for the gap between pipes with safe bounds
    final gapTop = Random().nextDouble() * availableHeight + safeMargin;
    final gapBottom = gapTop + pipeGap;

    // Create pipe pair
    // Top pipe - position at y=0 with the height going down to gapTop
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
    if (gameState == GameState.intro) {
      showMainMenu();
    } else if (gameState == GameState.mainMenu) {
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

    bird.reset();

    // Spawn the first pipe immediately
    _spawnPipe();

    // Start the timer for subsequent pipes
    interval.start();
  }

  void resetGame() {
    gameState = GameState.mainMenu;
    overlays.remove('GameOver');
    overlays.remove('Score');

    removeWhere((component) => component is Pipe);

    score = 0;
    isHit = false;

    bird.reset();
    interval.stop();

    showMainMenu();
  }

  void showIntro() {
    overlays.add('Intro');
  }

  void showMainMenu() {
    gameState = GameState.mainMenu;
    overlays.remove('Intro');
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

    overlays.remove('Score');
    overlays.add('Score');
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    if (gameState == GameState.playing) {
      if (bird.position.y > size.y - bird.size.y || bird.position.y < 0) {
        gameOver();
      }
    }
  }
}
