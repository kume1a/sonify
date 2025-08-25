import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'flappy_plane_game.dart';
import 'screens/game_over_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/score_display.dart';

class FlappyPlaneWidget extends StatelessWidget {
  const FlappyPlaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = FlappyPlaneGame();

    return GameWidget<FlappyPlaneGame>.controlled(
      gameFactory: () => game,
      overlayBuilderMap: {
        'MainMenu': (context, game) => MainMenuScreen(onStart: () => game.startGame()),
        'GameOver': (context, game) => GameOverScreen(score: game.score, onRestart: () => game.resetGame()),
        'Score': (context, game) => ScoreDisplay(score: game.score),
      },
    );
  }
}
