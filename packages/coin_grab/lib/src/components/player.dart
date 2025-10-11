import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';
import '../constants/assets.dart';

/// Animation states for the player character
enum PlayerAnimationState { idle, pointing, talking, victory, walking, running, celebration }

/// The player character component
class Player extends SpriteAnimationGroupComponent<PlayerAnimationState>
    with CollisionCallbacks, HasGameReference<CoinGrabGame> {
  static const double walkSpeed = 200.0;
  static const double runSpeed = 350.0;
  // Calculate proper aspect ratio - assuming sprite is roughly square but allowing for proper proportions
  static const double playerWidth = 56.0; // Increased width for better aspect ratio
  static const double playerHeight = 64.0; // Increased height to maintain character proportions

  late double _gameWidth;
  double _horizontalMovement = 0.0;
  bool _isCelebrating = false;
  bool _isUsingDragInput = false; // Flag to know if we're using drag or keyboard
  bool _isRunning = false; // Flag to differentiate walking vs running

  Player({required Vector2 position}) : super(position: position, size: Vector2(playerWidth, playerHeight)) {
    // Set anchor to center to prevent jumping when flipping horizontally
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add a hitbox that covers most of the player for better collision detection
    // Simple hitbox - Flame handles the parent's anchor automatically
    final hitbox = RectangleHitbox();

    // Enable debug mode to show hitbox outline
    hitbox.debugMode = true;
    await add(hitbox);

    log('Player hitbox loaded: full size, auto-positioned');

    // Load all animations and set the initial state
    animations = await _loadAnimations();
    current = PlayerAnimationState.idle;
  }

  Future<Map<PlayerAnimationState, SpriteAnimation>> _loadAnimations() async {
    try {
      log('Loading character sprites from: ${Assets.characterSpritesheet}');

      final spriteSheetImage = await game.images.load(Assets.characterSpritesheet);

      log(
        'Sprite sheet loaded successfully. Image size: ${spriteSheetImage.width}x${spriteSheetImage.height}',
      );

      // Spritesheet is 2x5 grid (2 rows, 5 columns)
      // Image dimensions: 629×369 pixels
      // Calculated frame dimensions: 126×185 pixels (evenly spaced)
      const int gridCols = 5;
      const int gridRows = 2;
      const double frameWidth = 126.0;
      const double frameHeight = 185.0;

      log('Grid: ${gridCols}x$gridRows');
      log('Frame dimensions: ${frameWidth}x$frameHeight (properly calculated for even spacing)');

      // Helper function to get a sprite by frame index (0-9)
      // No manual offset needed - using exact frame dimensions
      Sprite getSpriteByFrame(int frameIndex) {
        final int row = frameIndex ~/ gridCols; // 0 for top row, 1 for bottom row
        final int col = frameIndex % gridCols; // 0-4 for column position
        return Sprite(
          spriteSheetImage,
          srcPosition: Vector2(col * frameWidth, row * frameHeight),
          srcSize: Vector2(frameWidth, frameHeight),
        );
      }

      // Idle animation - frames 0, 4, or 9 (using frame 0 as primary)
      final idleSprites = [getSpriteByFrame(0)];
      final idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.5);

      // Pointing animation - frame 1
      final pointingSprites = [getSpriteByFrame(1)];
      final pointingAnimation = SpriteAnimation.spriteList(pointingSprites, stepTime: 0.3);

      // Talking animation - frame 2
      final talkingSprites = [getSpriteByFrame(2)];
      final talkingAnimation = SpriteAnimation.spriteList(talkingSprites, stepTime: 0.3);

      // Victory animation - frame 3
      final victorySprites = [getSpriteByFrame(3)];
      final victoryAnimation = SpriteAnimation.spriteList(victorySprites, stepTime: 0.2);

      // Walking animation - frames 5 and 6 (looped) - add more frames for smoother animation
      final walkingSprites = [
        getSpriteByFrame(5),
        getSpriteByFrame(6),
        getSpriteByFrame(5), // Repeat for smoother loop
        getSpriteByFrame(6),
      ];
      final walkingAnimation = SpriteAnimation.spriteList(walkingSprites, stepTime: 0.2);

      // Running animation - frames 7 and 8 (looped, faster) - add more frames
      final runningSprites = [
        getSpriteByFrame(7),
        getSpriteByFrame(8),
        getSpriteByFrame(7),
        getSpriteByFrame(8),
      ];
      final runningAnimation = SpriteAnimation.spriteList(runningSprites, stepTime: 0.12);

      // Celebration animation - using victory frame for now, can be customized
      final celebrationSprites = [getSpriteByFrame(3)];
      final celebrationAnimation = SpriteAnimation.spriteList(celebrationSprites, stepTime: 0.2);

      log('All animations created successfully with proper frame mapping');

      return {
        PlayerAnimationState.idle: idleAnimation,
        PlayerAnimationState.pointing: pointingAnimation,
        PlayerAnimationState.talking: talkingAnimation,
        PlayerAnimationState.victory: victoryAnimation,
        PlayerAnimationState.walking: walkingAnimation,
        PlayerAnimationState.running: runningAnimation,
        PlayerAnimationState.celebration: celebrationAnimation,
      };
    } catch (e) {
      log('Failed to load character sprites: $e');
      log('Stack trace: ${StackTrace.current}');
      return _createFallbackAnimations();
    }
  }

  Map<PlayerAnimationState, SpriteAnimation> _createFallbackAnimations() {
    log('Creating fallback animations - sprites failed to load');

    // Create animations that will make the hitbox visible by using an empty sprite list
    // This will help us identify if the issue is sprite loading vs rendering
    final stepTime = 0.2;
    final fallbackAnimation = SpriteAnimation.spriteList([], stepTime: stepTime);

    return {
      PlayerAnimationState.idle: fallbackAnimation,
      PlayerAnimationState.pointing: fallbackAnimation,
      PlayerAnimationState.talking: fallbackAnimation,
      PlayerAnimationState.victory: fallbackAnimation,
      PlayerAnimationState.walking: fallbackAnimation,
      PlayerAnimationState.running: fallbackAnimation,
      PlayerAnimationState.celebration: fallbackAnimation,
    };
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Stop all movement and animations during game over
    if (game.gameState == GameState.gameOver) {
      _horizontalMovement = 0.0;
      _isRunning = false;
      current = PlayerAnimationState.idle;
      return;
    }

    // Handle keyboard-based movement (when not using drag input)
    if (!_isUsingDragInput && _horizontalMovement != 0) {
      final currentSpeed = _isRunning ? runSpeed : walkSpeed;
      position.x += _horizontalMovement * currentSpeed * dt;
    }

    // Keep player within screen bounds (accounting for centered anchor)
    position.x = position.x.clamp(size.x / 2, _gameWidth - size.x / 2);

    // Update animation state based on input type
    if (_isCelebrating) {
      // Keep celebration animation
      current = PlayerAnimationState.celebration;
    } else if (!_isUsingDragInput && _horizontalMovement != 0) {
      // Keyboard movement animation - choose walking or running based on flag
      current = _isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    } else if (!_isUsingDragInput && _horizontalMovement == 0) {
      // Keyboard idle animation
      current = PlayerAnimationState.idle;
    }
    // Drag animation is handled by the setMoving* methods called from the game
  }

  // Drag input methods
  void setMovingLeft({bool isRunning = false}) {
    _isUsingDragInput = true;
    _isRunning = isRunning;
    scale.x = -1.0; // Flip sprite horizontally for left movement
    if (!_isCelebrating) {
      current = isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    }
  }

  void setMovingRight({bool isRunning = false}) {
    _isUsingDragInput = true;
    _isRunning = isRunning;
    scale.x = 1.0; // Normal orientation for right movement
    if (!_isCelebrating) {
      current = isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    }
  }

  void setIdle() {
    _isUsingDragInput = true;
    _isRunning = false;
    // Keep current facing direction when idle
    if (!_isCelebrating) current = PlayerAnimationState.idle;
  }

  // Keyboard input methods
  void moveLeft({bool isRunning = false}) {
    _isUsingDragInput = false;
    _horizontalMovement = -1.0;
    _isRunning = isRunning;
    scale.x = -1.0; // Flip sprite horizontally for left movement
  }

  void moveRight({bool isRunning = false}) {
    _isUsingDragInput = false;
    _horizontalMovement = 1.0;
    _isRunning = isRunning;
    scale.x = 1.0; // Normal orientation for right movement
  }

  void stopMovement() {
    _isUsingDragInput = false;
    _horizontalMovement = 0.0;
    _isRunning = false;
    // Keep current facing direction when stopped
  }

  // Running mode control
  void setRunningMode(bool isRunning) {
    _isRunning = isRunning;
  }

  void celebrate() {
    _isCelebrating = true;
    current = PlayerAnimationState.celebration;

    // Stop celebrating after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      _isCelebrating = false;
    });
  }

  /// Trigger pointing animation (for interactions or selecting)
  void pointAt() {
    if (!_isCelebrating) {
      current = PlayerAnimationState.pointing;
    }
  }

  /// Trigger talking animation (for dialogue or expressions)
  void talk() {
    if (!_isCelebrating) {
      current = PlayerAnimationState.talking;
    }
  }

  /// Trigger victory animation (for achievements or celebrations)
  void victory() {
    current = PlayerAnimationState.victory;

    // Return to idle after victory animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (current == PlayerAnimationState.victory) {
        current = PlayerAnimationState.idle;
      }
    });
  }

  /// Start running animation (faster movement)
  void startRunning() {
    _isRunning = true;
    if (!_isCelebrating) current = PlayerAnimationState.running;
  }

  void setGameWidth(double width) {
    _gameWidth = width;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print('Player collision detected with: ${other.runtimeType}');
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('Player ongoing collision with: ${other.runtimeType}');
  }
}
