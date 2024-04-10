import 'package:isar/isar.dart';

import '../../constant/collections.dart';
import '../audio/audio_entity.dart';

part 'user_audio_entity.g.dart';

@collection
@Name(UserAudioEntity_.collectionName)
class UserAudioEntity {
  Id? id = Isar.autoIncrement;

  int? createdAtMillis;

  String? bUserId;

  String? bAudioId;

  final audio = IsarLink<AudioEntity>();
}
