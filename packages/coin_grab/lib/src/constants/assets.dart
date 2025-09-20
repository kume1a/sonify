/// Asset constants for the Coin Grab game
class CoinGrabAssets {
  CoinGrabAssets._();

  // Asset path prefixes
  static const String _imagePrefix = 'packages/coin_grab/lib/assets/images/';
  static const String _soundPrefix = 'packages/coin_grab/lib/assets/sound/';

  // Image assets
  static const String characterSpritesPng = 'character_sprites_flame.png';
  static const String itemSpritesPng = 'item_sprites_flame.png';

  // All image assets list
  static const List<String> allImages = [characterSpritesPng, itemSpritesPng];

  // Getters for prefixes (to be used in game initialization)
  static String get imagePrefix => _imagePrefix;
  static String get soundPrefix => _soundPrefix;
}
