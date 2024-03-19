import 'package:isar/isar.dart';

import '../../constant/collections.dart';

part 'audio_entity.g.dart';

@collection
@Name(AudioEntity_.collectionName)
class AudioEntity {
  Id id = Isar.autoIncrement;

  String? title;

  int? duration;

  String? path;

  String? author;

  String? userId;

  int? sizeInBytes;

  String? youtubeVideoId;

  String? thumbnailPath;
}
