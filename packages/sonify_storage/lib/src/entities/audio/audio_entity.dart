import 'package:isar/isar.dart';

import '../../constant/collections.dart';

part 'audio_entity.g.dart';

@collection
@Name(AudioEntity_.collectionName)
class AudioEntity {
  Id id = Isar.autoIncrement;

  late String title;

  late String path;

  late int sizeInKb;
}
