import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onStart;

  const IntroScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.9),
      child: InkWell(
        onTap: onStart,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text(
                  'Coin Grab',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.yellow),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '• Move left and right to catch falling items\n'
                  '• Use arrow keys or A/D on desktop\n'
                  '• Use swipe gestures on mobile\n'
                  '• Coins = 10 points, Dollars = 5 points, Gold bars = 100 points\n'
                  '• Items fall faster as difficulty increases!\n'
                  '• Avoid bacon - it ends the game!',
                  style: TextStyle(fontSize: 16, color: Colors.white, height: 1.8),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text('Tap to Continue', style: TextStyle(fontSize: 18, color: Colors.grey.shade400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
