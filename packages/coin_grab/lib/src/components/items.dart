import 'package:flame/components.dart';

import 'collectible_item.dart';

/// A gold coin that the player can collect for points
class GoldCoin extends CollectibleItem {
  GoldCoin({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 150.0,
    super.points = 10,
  }) : super(size: Vector2(64, 64), itemType: 'gold_coin');

  @override
  void onCollected() {
    // Add particle effects or sound here later
    removeFromParent();
  }
}

/// A dollar bill that gives small bonus points
class DollarBill extends CollectibleItem {
  DollarBill({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 120.0,
    super.points = 5,
  }) : super(size: Vector2(64, 64), itemType: 'dollar_bill');

  @override
  void onCollected() {
    // Add special effects for dollar bill collection
    removeFromParent();
  }
}

/// A gold bar that gives lots of points
class GoldBar extends CollectibleItem {
  GoldBar({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 100.0,
    super.points = 100,
  }) : super(size: Vector2(64, 64), itemType: 'gold_bar');

  @override
  void onCollected() {
    // Add special effects for gold bar collection
    removeFromParent();
  }
}

/// Bacon - causes instant death/game over when caught
class Bacon extends CollectibleItem {
  Bacon({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 130.0,
    super.points = 0, // No points, causes death
  }) : super(size: Vector2(64, 64), itemType: 'bacon');

  @override
  void onCollected() {
    // This will trigger game over
    removeFromParent();
  }
}
