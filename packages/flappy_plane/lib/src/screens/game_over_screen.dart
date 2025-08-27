import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback? onGoBack;

  const GameOverScreen({super.key, required this.score, required this.onRestart, this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: onRestart, // Tap anywhere outside to restart
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent tap propagation from the popup itself
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Game Over',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text('Score: $score', style: const TextStyle(fontSize: 28, color: Colors.white)),
                  const SizedBox(height: 30),
                  // Go Back Button in the middle
                  if (onGoBack != null)
                    GestureDetector(
                      onTap: onGoBack,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400, width: 2),
                        ),
                        child: const Text(
                          'Go Back',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  // Caption about tapping outside
                  const Text(
                    'Tap outside to try again',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
