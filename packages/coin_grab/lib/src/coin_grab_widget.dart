import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'coin_grab_game.dart';

/// A Flutter widget that displays the coin grab game
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
          // Game widget
          GestureDetector(
            onPanStart: (details) {
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final localPosition = renderBox.globalToLocal(details.globalPosition);
                game.handleDragStart(localPosition.dx);
              }
            },
            onPanUpdate: (details) {
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final localPosition = renderBox.globalToLocal(details.globalPosition);
                game.handleDragUpdate(localPosition.dx);
              }
            },
            onPanEnd: (details) {
              game.handleDragEnd();
            },
            child: GameWidget(game: game),
          ),

          // Keyboard listener for desktop controls
          Focus(
            autofocus: true,
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (KeyEvent event) {
                final keysPressed = <LogicalKeyboardKey>{};

                if (event is KeyDownEvent) {
                  keysPressed.add(event.logicalKey);
                } else if (event is KeyRepeatEvent) {
                  keysPressed.add(event.logicalKey);
                }

                // Handle keyboard input for player movement
                final isLeftPressed =
                    keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
                    keysPressed.contains(LogicalKeyboardKey.keyA);
                final isRightPressed =
                    keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
                    keysPressed.contains(LogicalKeyboardKey.keyD);

                if (event is KeyDownEvent || event is KeyRepeatEvent) {
                  if (isLeftPressed && !isRightPressed) {
                    game.player.moveLeft();
                  } else if (isRightPressed && !isLeftPressed) {
                    game.player.moveRight();
                  }
                } else if (event is KeyUpEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                      event.logicalKey == LogicalKeyboardKey.keyA ||
                      event.logicalKey == LogicalKeyboardKey.arrowRight ||
                      event.logicalKey == LogicalKeyboardKey.keyD) {
                    game.player.stopMovement();
                  }
                }
              },
              child: Container(), // Empty container just to capture keyboard focus
            ),
          ),

          // Back button
          if (widget.onGoBack != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                onPressed: widget.onGoBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              ),
            ),
        ],
      ),
    );
  }
}
