import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'flappy_plane_game.dart';
import 'screens/game_over_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/score_display.dart';

class FlappyPlaneWidget extends StatefulWidget {
  final VoidCallback? onGoBack;

  const FlappyPlaneWidget({super.key, this.onGoBack});

  @override
  State<FlappyPlaneWidget> createState() => _FlappyPlaneWidgetState();
}

class _FlappyPlaneWidgetState extends State<FlappyPlaneWidget> {
  late final FlappyPlaneGame game;

  @override
  void initState() {
    super.initState();
    game = FlappyPlaneGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => game.handleTap(),
      child: GameWidget<FlappyPlaneGame>.controlled(
        gameFactory: () => game,
        overlayBuilderMap: {
          'Intro': (context, game) => IntroScreen(onStart: () => game.showMainMenu()),
          'MainMenu': (context, game) => MainMenuScreen(onStart: () => game.startGame()),
          'GameOver': (context, game) =>
              GameOverScreen(score: game.score, onRestart: () => game.resetGame(), onGoBack: widget.onGoBack),
          'Score': (context, game) => ScoreDisplay(score: game.score),
        },
      ),
    );
  }
}
