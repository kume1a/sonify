import 'package:isar/isar.dart';

import '../../constant/collections.dart';
import '../audio/audio_entity.dart';

part 'audio_like_entity.g.dart';

@collection
@Name(AudioLikeEntity_.collectionName)
class AudioLikeEntity {
  Id? id = Isar.autoIncrement;

  String? audioId;

  String? userId;

  int? localAudioId;

  final audio = IsarLink<AudioEntity>();
}
