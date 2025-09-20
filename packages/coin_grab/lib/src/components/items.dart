import 'package:flame/components.dart';

import 'collectible_item.dart';

/// A coin that the player can collect for points
class Coin extends CollectibleItem {
  Coin({required super.sprite, required Vector2 super.position, super.fallSpeed = 150.0, super.points = 10})
    : super(size: Vector2(32, 32), itemType: 'coin');

  @override
  void onCollected() {
    // Add particle effects or sound here later
    removeFromParent();
  }
}

/// A gem that gives bonus points
class Gem extends CollectibleItem {
  Gem({required super.sprite, required Vector2 super.position, super.fallSpeed = 120.0, super.points = 50})
    : super(size: Vector2(40, 40), itemType: 'gem');

  @override
  void onCollected() {
    // Add special effects for gem collection
    removeFromParent();
  }
}

/// A money bag that gives lots of points
class MoneyBag extends CollectibleItem {
  MoneyBag({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 100.0,
    super.points = 100,
  }) : super(size: Vector2(48, 48), itemType: 'money_bag');

  @override
  void onCollected() {
    // Add special effects for money bag collection
    removeFromParent();
  }
}
