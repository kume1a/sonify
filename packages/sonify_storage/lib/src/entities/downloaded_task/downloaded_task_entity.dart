import '../../../sonify_storage.dart';

class DownloadedTaskEntity {
  DownloadedTaskEntity({
    required this.id,
    required this.bUserId,
    required this.taskId,
    required this.savePath,
    required this.fileType,
    required this.payloadUserAudioId,
    required this.payloadUserAudio,
  });

  final int? id;
  final String? bUserId;
  final String? taskId;
  final String? savePath;
  final String? fileType;
  final int? payloadUserAudioId;
  final UserAudioEntity? payloadUserAudio;
}
