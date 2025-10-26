import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../coin_grab_game.dart';
import '../constants/assets.dart';

enum PlayerAnimationState { idle, pointing, talking, victory, walking, running, celebration }

class Player extends SpriteAnimationGroupComponent<PlayerAnimationState>
    with CollisionCallbacks, HasGameReference<CoinGrabGame> {
  static const double walkSpeed = 200.0;
  static const double runSpeed = 350.0;
  static const double playerHeight = 80.0;
  static const double playerWidth = playerHeight * (126.0 / 185.0);

  late double _gameWidth;
  double _horizontalMovement = 0.0;
  bool _isCelebrating = false;
  bool _isUsingDragInput = false;
  bool _isRunning = false;

  Player({required Vector2 position}) : super(position: position, size: Vector2(playerWidth, playerHeight)) {
    // Set anchor to center to prevent jumping when flipping horizontally
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final hitbox = RectangleHitbox();
    hitbox.debugMode = false;
    await add(hitbox);

    animations = await _loadAnimations();
    current = PlayerAnimationState.idle;
  }

  Future<Map<PlayerAnimationState, SpriteAnimation>> _loadAnimations() async {
    try {
      final spriteSheetImage = await game.images.load(Assets.characterSpritesheet);

      const int gridCols = 5;
      const double frameWidth = 126.0;
      const double frameHeight = 185.0;

      Sprite getSpriteByFrame(int frameIndex) {
        final int row = frameIndex ~/ gridCols;
        final int col = frameIndex % gridCols;
        return Sprite(
          spriteSheetImage,
          srcPosition: Vector2(col * frameWidth, row * frameHeight),
          srcSize: Vector2(frameWidth, frameHeight),
        );
      }

      final idleAnimation = SpriteAnimation.spriteList([getSpriteByFrame(0)], stepTime: 0.5);
      final pointingAnimation = SpriteAnimation.spriteList([getSpriteByFrame(1)], stepTime: 0.3);
      final talkingAnimation = SpriteAnimation.spriteList([getSpriteByFrame(2)], stepTime: 0.3);
      final victoryAnimation = SpriteAnimation.spriteList([getSpriteByFrame(3)], stepTime: 0.2);

      final walkingAnimation = SpriteAnimation.spriteList([
        getSpriteByFrame(5),
        getSpriteByFrame(6),
        getSpriteByFrame(5),
        getSpriteByFrame(6),
      ], stepTime: 0.2);

      final runningAnimation = SpriteAnimation.spriteList([
        getSpriteByFrame(7),
        getSpriteByFrame(8),
        getSpriteByFrame(7),
        getSpriteByFrame(8),
      ], stepTime: 0.12);

      final celebrationAnimation = SpriteAnimation.spriteList([getSpriteByFrame(3)], stepTime: 0.2);

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
      return _createFallbackAnimations();
    }
  }

  Map<PlayerAnimationState, SpriteAnimation> _createFallbackAnimations() {
    final fallbackAnimation = SpriteAnimation.spriteList([], stepTime: 0.2);

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

    if (game.gameState == GameState.gameOver) {
      _horizontalMovement = 0.0;
      _isRunning = false;
      current = PlayerAnimationState.idle;
      return;
    }

    if (!_isUsingDragInput && _horizontalMovement != 0) {
      final currentSpeed = _isRunning ? runSpeed : walkSpeed;
      position.x += _horizontalMovement * currentSpeed * dt;
    }

    position.x = position.x.clamp(size.x / 2, _gameWidth - size.x / 2);

    if (_isCelebrating) {
      current = PlayerAnimationState.celebration;
    } else if (!_isUsingDragInput && _horizontalMovement != 0) {
      current = _isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    } else if (!_isUsingDragInput && _horizontalMovement == 0) {
      current = PlayerAnimationState.idle;
    }
  }

  void setMovingLeft({bool isRunning = false}) {
    _isUsingDragInput = true;
    _isRunning = isRunning;
    scale.x = -1.0;
    if (!_isCelebrating) {
      current = isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    }
  }

  void setMovingRight({bool isRunning = false}) {
    _isUsingDragInput = true;
    _isRunning = isRunning;
    scale.x = 1.0;
    if (!_isCelebrating) {
      current = isRunning ? PlayerAnimationState.running : PlayerAnimationState.walking;
    }
  }

  void setIdle() {
    _isUsingDragInput = true;
    _isRunning = false;
    if (!_isCelebrating) current = PlayerAnimationState.idle;
  }

  void moveLeft({bool isRunning = false}) {
    _isUsingDragInput = false;
    _horizontalMovement = -1.0;
    _isRunning = isRunning;
    scale.x = -1.0;
  }

  void moveRight({bool isRunning = false}) {
    _isUsingDragInput = false;
    _horizontalMovement = 1.0;
    _isRunning = isRunning;
    scale.x = 1.0;
  }

  void stopMovement() {
    _isUsingDragInput = false;
    _horizontalMovement = 0.0;
    _isRunning = false;
  }

  void setRunningMode(bool isRunning) {
    _isRunning = isRunning;
  }

  void celebrate() {
    _isCelebrating = true;
    current = PlayerAnimationState.celebration;

    Future.delayed(const Duration(milliseconds: 800), () {
      _isCelebrating = false;
    });
  }

  void pointAt() {
    if (!_isCelebrating) {
      current = PlayerAnimationState.pointing;
    }
  }

  void talk() {
    if (!_isCelebrating) {
      current = PlayerAnimationState.talking;
    }
  }

  void victory() {
    current = PlayerAnimationState.victory;

    Future.delayed(const Duration(milliseconds: 600), () {
      if (current == PlayerAnimationState.victory) {
        current = PlayerAnimationState.idle;
      }
    });
  }

  void startRunning() {
    _isRunning = true;
    if (!_isCelebrating) current = PlayerAnimationState.running;
  }

  void setGameWidth(double width) {
    _gameWidth = width;
  }
}
