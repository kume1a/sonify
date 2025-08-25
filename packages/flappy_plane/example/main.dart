import 'package:flappy_plane/flappy_plane.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlappyPlaneApp());
}

class FlappyPlaneApp extends StatelessWidget {
  const FlappyPlaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Plane',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: FlappyPlaneWidget()),
      debugShowCheckedModeBanner: false,
    );
  }
}
