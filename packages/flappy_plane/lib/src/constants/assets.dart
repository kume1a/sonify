class Assets {
  Assets._();

  // Asset path prefixes
  static const String _imagePrefix = 'packages/flappy_plane/lib/assets/images/';
  static const String _soundPrefix = 'packages/flappy_plane/lib/assets/sound/';

  // Image assets
  static const String planePng = 'plane.png';
  static const String towerPng = 'tower.png';
  static const String osamaPng = 'osama.png';
  static const String osamaHeadPng = 'osama_head.png';
  static const String explosionAtlasPng = 'explosion_atlas.png';

  // Background images
  static const String background1Png = 'background/1.png';
  static const String background2Png = 'background/2.png';
  static const String background3Png = 'background/3.png';
  static const String background4Png = 'background/4.png';
  static const String background5Png = 'background/5.png';
  static const String background6Png = 'background/6.png';

  static const List<String> backgroundImages = [
    background1Png,
    background2Png,
    background3Png,
    background4Png,
    background5Png,
    background6Png,
  ];

  static const List<String> allImages = [
    planePng,
    towerPng,
    osamaPng,
    osamaHeadPng,
    explosionAtlasPng,
    ...backgroundImages,
  ];

  // Audio assets
  static const String alahuakbarMp3 = 'alahuakbar.mp3';
  static const String explosionMp3 = 'explosion.mp3';

  // Full asset paths (with package prefix for Image.asset usage)
  static const String osamaFullPath = '${_imagePrefix}osama.png';

  // Getters for prefixes (to be used in game initialization)
  static String get imagePrefix => _imagePrefix;
  static String get soundPrefix => _soundPrefix;
}
