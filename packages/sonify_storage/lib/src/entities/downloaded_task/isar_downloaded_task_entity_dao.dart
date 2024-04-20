import 'package:isar/isar.dart';

import '../user_audio/user_audio_entity.dart';
import 'downloaded_task_entity.dart';
import 'downloaded_task_entity_dao.dart';

class IsarDownloadedTaskEntityDao implements DownloadedTaskEntityDao {
  IsarDownloadedTaskEntityDao(this._isar);

  final Isar _isar;

  @override
  Future<int> insert(
    DownloadedTaskEntity entity, {
    UserAudioEntity? payloadUserAudioEntity,
  }) {
    if (payloadUserAudioEntity != null) {
      entity.payloadUserAudio.value = payloadUserAudioEntity;
    }

    return _isar.writeTxn(() async {
      final downloadedTaskEntityId = await _isar.collection<DownloadedTaskEntity>().put(entity);

      await entity.payloadUserAudio.save();

      return downloadedTaskEntityId;
    });
  }

  @override
  Future<List<DownloadedTaskEntity>> getAllByUserId(String userId) async {
    final res = await _isar.collection<DownloadedTaskEntity>().filter().userIdEqualTo(userId).findAll();

    await Future.wait(res.map((e) => e.payloadUserAudio.load()));

    return res;
  }
}
