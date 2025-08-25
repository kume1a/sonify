import 'package:flappy_plane/flappy_plane.dart';
import 'package:flutter/material.dart';

class FlappyPlanePage extends StatelessWidget {
  const FlappyPlanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Flappy Plane',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Game area
            Expanded(
              child: FlappyPlaneWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
