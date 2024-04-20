import 'package:isar/isar.dart';

import '../../../sonify_storage.dart';
import '../../constant/collections.dart';

part 'downloaded_task_entity.g.dart';

@collection
@Name(DownloadTaskEntity_.collectionName)
class DownloadedTaskEntity {
  Id? id = Isar.autoIncrement;

  int? createdAtMillis;

  String? userId;

  String? taskId;

  String? savePath;

  String? fileType;

  final payloadUserAudio = IsarLink<UserAudioEntity>();
}
