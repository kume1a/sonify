import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import 'query_local_music_artwork.dart';

@LazySingleton(as: QueryLocalMusicArtwork)
class NoopQueryLocalMusicArtworkImpl implements QueryLocalMusicArtwork {
  NoopQueryLocalMusicArtworkImpl();

  @override
  Future<Uint8List?> call({
    required int localMusicId,
  }) {
    throw UnimplementedError('NoopQueryLocalMusicArtworkImpl is not implemented');
  }
}
