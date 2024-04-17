import 'package:isar/isar.dart';

import 'user_audio_dao.dart';
import 'user_audio_entity.dart';

class IsarUserAudioEntityDao implements UserAudioEntityDao {
  IsarUserAudioEntityDao(this._isar);

  final Isar _isar;

  @override
  Future<List<UserAudioEntity>> getAllByUserId(String userId) async {
    final res = await _isar.collection<UserAudioEntity>().filter().bUserIdEqualTo(userId).findAll();

    await Future.wait(res.map((e) => e.audio.load()));

    return res;
  }

  @override
  Future<int> deleteByIds(List<int> ids) {
    return _isar.writeTxn(() => _isar.collection<UserAudioEntity>().deleteAll(ids));
  }
}
