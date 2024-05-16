import '../../../sonify_storage.dart';

class DownloadedTaskEntity {
  DownloadedTaskEntity({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.savePath,
    required this.fileType,
    required this.payloadUserAudioId,
    required this.payloadUserAudio,
  });

  final int? id;
  final String? userId;
  final String? taskId;
  final String? savePath;
  final String? fileType;
  final int? payloadUserAudioId;
  final UserAudioEntity? payloadUserAudio;
}
