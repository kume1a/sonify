import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final VoidCallback onStart;

  const MainMenuScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: InkWell(
        onTap: onStart,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Coin Grab',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Catch the falling coins!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Tap to Start',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
