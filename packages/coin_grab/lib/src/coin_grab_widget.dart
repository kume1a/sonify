import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'coin_grab_game.dart';
import 'screens/game_over_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/score_display.dart';

class CoinGrabWidget extends StatefulWidget {
  final VoidCallback? onGoBack;

  const CoinGrabWidget({super.key, this.onGoBack});

  @override
  State<CoinGrabWidget> createState() => _CoinGrabWidgetState();
}

class _CoinGrabWidgetState extends State<CoinGrabWidget> {
  late CoinGrabGame game;

  @override
  void initState() {
    super.initState();
    game = CoinGrabGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => game.handleTap(),
            onPanStart: (details) {
              if (game.gameState == GameState.playing) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  game.handleDragStart(localPosition.dx);
                }
              }
            },
            onPanUpdate: (details) {
              if (game.gameState == GameState.playing) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  game.handleDragUpdate(localPosition.dx);
                }
              }
            },
            onPanEnd: (details) {
              if (game.gameState == GameState.playing) {
                game.handleDragEnd();
              }
            },
            child: GameWidget<CoinGrabGame>.controlled(
              gameFactory: () => game,
              overlayBuilderMap: {
                'Intro': (context, game) => IntroScreen(onStart: () => game.showMainMenu()),
                'MainMenu': (context, game) => MainMenuScreen(onStart: () => game.startGame()),
                'GameOver': (context, game) => GameOverScreen(
                  score: game.score,
                  onRestart: () => game.resetGame(),
                  onGoBack: widget.onGoBack,
                ),
                'Score': (context, game) => Stack(
                  children: [
                    ScoreDisplay(
                      score: game.score,
                      missedItems: game.missedItems,
                      maxMissedItems: CoinGrabGame.maxMissedItems,
                    ),
                    // Debug score display in corner
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DEBUG: S:${game.score} M:${game.missedItems}/${CoinGrabGame.maxMissedItems}',
                          style: const TextStyle(color: Colors.yellow, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
