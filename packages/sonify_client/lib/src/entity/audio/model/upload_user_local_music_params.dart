import 'dart:typed_data';

class UploadUserLocalMusicParams {
  UploadUserLocalMusicParams({
    required this.localId,
    required this.title,
    required this.author,
    required this.durationMs,
    required this.audio,
    required this.thumbnail,
  });

  final String localId;
  final String title;
  final String author;
  final int durationMs;
  final Uint8List audio;
  final Uint8List? thumbnail;
}
