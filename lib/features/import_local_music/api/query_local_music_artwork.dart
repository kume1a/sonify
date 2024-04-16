import 'dart:typed_data';

abstract interface class QueryLocalMusicArtwork {
  Future<Uint8List?> call({
    required int localMusicId,
  });
}
