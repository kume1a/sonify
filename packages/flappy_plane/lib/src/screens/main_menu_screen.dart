import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final VoidCallback onStart;

  const MainMenuScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flappy Plane',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Tap to Start',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap or press Space to fly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
