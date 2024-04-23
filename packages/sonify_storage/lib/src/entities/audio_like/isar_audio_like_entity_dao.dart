import 'package:isar/isar.dart';

import 'audio_like_entity.dart';
import 'audio_like_entity_dao.dart';

class IsarAudioLikeEntityDao implements AudioLikeEntityDao {
  IsarAudioLikeEntityDao(this._isar);

  final Isar _isar;

  @override
  Future<int> insert(AudioLikeEntity entity) {
    return _isar.writeTxn(() => _isar.collection<AudioLikeEntity>().put(entity));
  }
}
