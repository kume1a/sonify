import 'package:isar/isar.dart';

import '../../constant/collections.dart';

part 'song_entity.g.dart';

@collection
@Name(SontEntity_.collectionName)
class SongEntity {
  Id id = Isar.autoIncrement;

  late String title;

  late String path;

  late int sizeInKb;
}
