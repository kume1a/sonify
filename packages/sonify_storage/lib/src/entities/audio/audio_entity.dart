import 'package:isar/isar.dart';

import '../../constant/collections.dart';

part 'audio_entity.g.dart';

@collection
@Name(AudioEntity_.collectionName)
class AudioEntity {
  Id? id = Isar.autoIncrement;

  String? remoteId;

  int? createdAtMillis;

  String? title;

  int? durationMs;

  String? path;

  String? author;

  int? sizeBytes;

  String? youtubeVideoId;

  String? spotifyId;

  String? thumbnailPath;

  String? thumbnailUrl;
}
