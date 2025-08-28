import 'package:flutter/material.dart';

import '../constants/assets.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onStart;

  const IntroScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.7),
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
                  'Flappy Plane',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Text(
                '9/11 Edition',
                style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Image.asset(FlappyPlaneAssets.osamaFullPath, width: 200, height: 200, fit: BoxFit.cover),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text('Tap to Start', style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
