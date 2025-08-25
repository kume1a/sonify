import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverScreen({super.key, required this.score, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
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
              const Text('Tap to Try Again', style: TextStyle(fontSize: 20, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
