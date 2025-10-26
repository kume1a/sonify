class Assets {
  Assets._();

  // Asset path prefixes
  static const String _imagePrefix = 'packages/coin_grab/lib/assets/images/';
  static const String _soundPrefix = 'packages/coin_grab/lib/assets/sound/';

  // Image assets
  static const String characterSpritesheet = 'character_spritesheet.png';
  static const String itemSpritesheet = 'coingrab_items.png';

  static const List<String> allImages = [characterSpritesheet, itemSpritesheet];

  // Sound assets
  static const String havaNagilaMusic = 'hava_nagila.mp3';

  // Getters for prefixes (to be used in game initialization)
  static String get imagePrefix => _imagePrefix;
  static String get soundPrefix => _soundPrefix;
}
