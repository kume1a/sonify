import 'package:flame/components.dart';

import 'collectible_item.dart';

class GoldCoin extends CollectibleItem {
  GoldCoin({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 150.0,
    super.points = 10,
  }) : super(size: Vector2(64, 64), itemType: 'gold_coin');

  @override
  void onCollected() {
    removeFromParent();
  }
}

class DollarBill extends CollectibleItem {
  DollarBill({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 120.0,
    super.points = 5,
  }) : super(size: Vector2(64, 64), itemType: 'dollar_bill');

  @override
  void onCollected() {
    removeFromParent();
  }
}

class GoldBar extends CollectibleItem {
  GoldBar({
    required super.sprite,
    required Vector2 super.position,
    super.fallSpeed = 100.0,
    super.points = 100,
  }) : super(size: Vector2(64, 64), itemType: 'gold_bar');

  @override
  void onCollected() {
    removeFromParent();
  }
}

class Bacon extends CollectibleItem {
  Bacon({required super.sprite, required Vector2 super.position, super.fallSpeed = 130.0, super.points = 0})
    : super(size: Vector2(64, 64), itemType: 'bacon');

  @override
  void onCollected() {
    removeFromParent();
  }
}
