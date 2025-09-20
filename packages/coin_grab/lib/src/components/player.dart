import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';
import '../constants/assets.dart';

/// Animation states for the player character
enum PlayerAnimationState { idle, walking, celebration }

/// The player character component
class Player extends SpriteAnimationGroupComponent<PlayerAnimationState>
    with HasCollisionDetection, CollisionCallbacks, HasGameReference<CoinGrabGame> {
  static const double moveSpeed = 200.0;
  static const double playerWidth = 48.0;
  static const double playerHeight = 48.0;

  late double _gameWidth;
  double _horizontalMovement = 0.0;
  bool _isCelebrating = false;
  bool _isUsingDragInput = false; // Flag to know if we're using drag or keyboard

  Player({required Vector2 position}) : super(position: position, size: Vector2(playerWidth, playerHeight)) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load all animations and set the initial state
    animations = await _loadAnimations();
    current = PlayerAnimationState.idle;
  }

  Future<Map<PlayerAnimationState, SpriteAnimation>> _loadAnimations() async {
    try {
      print('Loading character sprites from: ${Assets.characterSpritesheet}');

      // 1. Load the sprite sheet image from game assets
      final spriteSheetImage = await game.images.load(Assets.characterSpritesheet);

      print(
        'Sprite sheet loaded successfully. Image size: ${spriteSheetImage.width}x${spriteSheetImage.height}',
      );

      // 2. Calculate exact frame dimensions
      // 1024x1024 sheet divided into 13x13 grid
      final int sheetWidth = spriteSheetImage.width;
      final int sheetHeight = spriteSheetImage.height;
      const int gridCols = 13;
      const int gridRows = 13;

      final double frameWidth = sheetWidth / gridCols;
      final double frameHeight = sheetHeight / gridRows;
      const double stepTime = 0.15;

      print('Sheet dimensions: ${sheetWidth}x$sheetHeight');
      print('Grid: ${gridCols}x$gridRows');
      print('Frame dimensions: ${frameWidth}x$frameHeight');

      // Idle animation - using first frame (position 0,0)
      final idleSprites = [
        Sprite(spriteSheetImage, srcPosition: Vector2(0, 0), srcSize: Vector2(frameWidth, frameHeight)),
      ];
      final idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.5);

      // Walking animation - using frames from the first row
      final walkingSprites = <Sprite>[];
      for (int i = 1; i < 5; i++) {
        // Use frames 1-4 from first row
        walkingSprites.add(
          Sprite(
            spriteSheetImage,
            srcPosition: Vector2(i * frameWidth, 0), // First row
            srcSize: Vector2(frameWidth, frameHeight),
          ),
        );
      }
      final walkingAnimation = SpriteAnimation.spriteList(walkingSprites, stepTime: stepTime);

      // Celebration animation - using frame from second row
      final celebrationSprites = [
        Sprite(
          spriteSheetImage,
          srcPosition: Vector2(0, frameHeight), // Second row, first column
          srcSize: Vector2(frameWidth, frameHeight),
        ),
      ];
      final celebrationAnimation = SpriteAnimation.spriteList(celebrationSprites, stepTime: 0.2);

      print('All animations created successfully');

      return {
        PlayerAnimationState.idle: idleAnimation,
        PlayerAnimationState.walking: walkingAnimation,
        PlayerAnimationState.celebration: celebrationAnimation,
      };
    } catch (e) {
      print('Failed to load character sprites: $e');
      print('Stack trace: ${StackTrace.current}');
      return _createFallbackAnimations();
    }
  }

  Map<PlayerAnimationState, SpriteAnimation> _createFallbackAnimations() {
    print('Creating fallback animations - sprites failed to load');

    // Since we can't create colored sprites easily, let's try to use a simple approach
    // Create animations that will make the hitbox visible by using an empty sprite list
    // This will help us identify if the issue is sprite loading vs rendering
    final stepTime = 0.2;
    final fallbackAnimation = SpriteAnimation.spriteList([], stepTime: stepTime);

    return {
      PlayerAnimationState.idle: fallbackAnimation,
      PlayerAnimationState.walking: fallbackAnimation,
      PlayerAnimationState.celebration: fallbackAnimation,
    };
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle keyboard-based movement (when not using drag input)
    if (!_isUsingDragInput && _horizontalMovement != 0) {
      position.x += _horizontalMovement * moveSpeed * dt;
    }

    // Keep player within screen bounds
    position.x = position.x.clamp(0, _gameWidth - size.x);

    // Update animation state based on input type
    if (_isCelebrating) {
      // Keep celebration animation
      current = PlayerAnimationState.celebration;
    } else if (!_isUsingDragInput && _horizontalMovement != 0) {
      // Keyboard movement animation
      current = PlayerAnimationState.walking;
    } else if (!_isUsingDragInput && _horizontalMovement == 0) {
      // Keyboard idle animation
      current = PlayerAnimationState.idle;
    }
    // Drag animation is handled by the setMoving* methods called from the game
  }

  // Drag input methods
  void setMovingLeft() {
    _isUsingDragInput = true;
    if (!_isCelebrating) current = PlayerAnimationState.walking;
  }

  void setMovingRight() {
    _isUsingDragInput = true;
    if (!_isCelebrating) current = PlayerAnimationState.walking;
  }

  void setIdle() {
    _isUsingDragInput = true;
    if (!_isCelebrating) current = PlayerAnimationState.idle;
  }

  // Keyboard input methods
  void moveLeft() {
    _isUsingDragInput = false;
    _horizontalMovement = -1.0;
  }

  void moveRight() {
    _isUsingDragInput = false;
    _horizontalMovement = 1.0;
  }

  void stopMovement() {
    _isUsingDragInput = false;
    _horizontalMovement = 0.0;
  }

  void celebrate() {
    _isCelebrating = true;
    current = PlayerAnimationState.celebration;

    // Stop celebrating after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      _isCelebrating = false;
    });
  }

  void setGameWidth(double width) {
    _gameWidth = width;
  }
}
