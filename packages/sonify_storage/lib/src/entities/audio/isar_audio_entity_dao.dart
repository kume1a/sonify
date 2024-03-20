import 'package:isar/isar.dart';

import 'audio_entity.dart';
import 'audio_entity_dao.dart';

class IsarAudioEntityDao implements AudioEntityDao {
  IsarAudioEntityDao(this._isar);

  final Isar _isar;

  @override
  Future<List<AudioEntity>> getAllByUserId(String userId) {
    return _isar.collection<AudioEntity>().filter().userIdEqualTo(userId).findAll();
  }

  @override
  Future<void> insert(AudioEntity entity) {
    return _isar.writeTxn(() => _isar.collection<AudioEntity>().put(entity));
  }

  @override
  Future<AudioEntity?> getById(int id) {
    return _isar.collection<AudioEntity>().filter().idEqualTo(id).findFirst();
  }
}
