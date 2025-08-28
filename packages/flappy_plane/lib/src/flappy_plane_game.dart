import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'components/background.dart';
import 'components/bird.dart';
import 'components/explosion.dart';
import 'components/osama_head.dart';
import 'components/pipe.dart';
import 'constants/assets.dart';

enum GameState { intro, mainMenu, playing, gameOver }

class FlappyPlaneGame extends FlameGame with HasCollisionDetection {
  late Bird bird;
  late Background background;
  Timer interval = Timer(2.75, repeat: true);
  bool isHit = false;
  int score = 0;
  GameState gameState = GameState.intro;

  @override
  Future<void> onLoad() async {
    images.prefix = FlappyPlaneAssets.imagePrefix;
    FlameAudio.audioCache.prefix = FlappyPlaneAssets.soundPrefix;

    await images.loadAll(FlappyPlaneAssets.allImages);

    background = Background();
    add(background);

    bird = Bird();
    add(bird);

    _spawnPipe();

    interval.onTick = () => _spawnPipe();

    showIntro();
  }

  void _spawnPipe() {
    if (gameState != GameState.playing) return;

    final screenHeight = size.y;
    final pipeGap = 220.0;
    final pipeWidth = 80.0;

    final safeMargin = 100.0;
    final availableHeight = screenHeight - pipeGap - (2 * safeMargin);

    final gapTop = Random().nextDouble() * availableHeight + safeMargin;
    final gapBottom = gapTop + pipeGap;

    final topPipe = Pipe(position: Vector2(size.x, 0), size: Vector2(pipeWidth, gapTop), isTop: true);

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

    final osamaHead = OsamaHead();
    add(osamaHead);
    osamaHead.show();

    interval.start();
  }

  void resetGame() {
    gameState = GameState.mainMenu;
    overlays.remove('GameOver');
    overlays.remove('Score');

    removeWhere((component) => component is Pipe);
    removeWhere((component) => component is Explosion);

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

  void gameOver([Vector2? collisionPoint]) {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;
    interval.stop();
    overlays.remove('Score');

    if (collisionPoint != null) {
      createExplosion(collisionPoint, () {
        overlays.add('GameOver');
      });
    } else {
      overlays.add('GameOver');
    }
  }

  void createExplosion(Vector2 position, [VoidCallback? onComplete]) {
    final explosion = Explosion(position: position, onComplete: onComplete);
    add(explosion);
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
      if (!bird.isCrashed && (bird.position.y > size.y - bird.size.y || bird.position.y < 0)) {
        final explosionPoint = Vector2(
          bird.position.x + bird.size.x * 0.1,
          bird.position.y + bird.size.y / 2,
        );

        bird.isCrashed = true;
        bird.angularVelocity = 2.0;

        gameOver(explosionPoint);
      }
    }
  }
}
