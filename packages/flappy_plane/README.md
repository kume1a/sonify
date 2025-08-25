# Flappy Plane

A Flappy Bird-style game built with Flutter and Flame game engine, featuring a plane as the bird, towers as pipes, and beautiful parallax background layers.

## Features

- **Plane as Bird**: Uses a plane sprite instead of the traditional bird
- **Tower Obstacles**: Tower sprites serve as the pipe obstacles
- **Parallax Background**: Multiple background layers with different speeds create a dynamic parallax scrolling effect
- **Collision Detection**: Physics-based collision detection
- **Score System**: Track your score as you pass through obstacles
- **Responsive Touch Controls**: Tap to make the plane fly
- **Game States**: Main menu, playing, and game over screens

## Getting Started

### Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flappy_plane: ^0.0.1
```

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flappy_plane/flappy_plane.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlappyPlaneWidget(),
      ),
    );
  }
}
```

### Assets

The package includes the following assets:
- `lib/assets/plane.png` - The plane sprite (bird)
- `lib/assets/tower.png` - The tower sprite (pipes)
- `lib/assets/background/1.png` to `lib/assets/background/7.png` - Background layers for parallax effect

### Game Components

- **FlappyPlaneGame**: The main game class
- **FlappyPlaneWidget**: A Flutter widget that wraps the game
- **Bird**: The player-controlled plane component
- **Pipe**: The obstacle components (towers)
- **Background**: Multi-layer parallax background system
- **Ground**: The ground collision component

### Controls

- **Tap**: Make the plane fly upward
- **Gravity**: The plane naturally falls down due to gravity
- **Collision**: Game ends when the plane hits towers or ground

### Game Flow

1. **Main Menu**: Shows when the game starts
2. **Playing**: Tap to control the plane, avoid towers, collect points
3. **Game Over**: Shows score and allows restart

## Customization

You can extend the game by:
- Modifying sprite assets
- Adjusting game physics (gravity, jump force, speed)
- Adding power-ups or special effects
- Implementing different difficulty levels
- Adding sound effects and music

## Technical Details

Built with:
- **Flutter**: UI framework
- **Flame**: 2D game engine
- **Collision Detection**: Physics-based collision system
- **Component System**: Modular game architecture

## License

This project is licensed under the MIT License.
