import 'package:flappy_plane/flappy_plane.dart';
import 'package:flutter/material.dart';

class FlappyPlanePage extends StatelessWidget {
  const FlappyPlanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FlappyPlaneWidget(
        onGoBack: () => Navigator.of(context).pop(),
      ),
    );
  }
}
