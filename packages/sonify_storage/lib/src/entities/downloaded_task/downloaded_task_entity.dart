import '../../../sonify_storage.dart';

class DownloadedTaskEntity {
  DownloadedTaskEntity({
    required this.id,
    required this.userId,
    required this.savePath,
    required this.fileType,
    required this.payloadUserAudioId,
    required this.payloadUserAudio,
  });

  final String? id;
  final String? userId;
  final String? savePath;
  final String? fileType;
  final String? payloadUserAudioId;
  final UserAudioEntity? payloadUserAudio;

  DownloadedTaskEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<String?>? userId,
    Wrapped<String?>? savePath,
    Wrapped<String?>? fileType,
    Wrapped<String?>? payloadUserAudioId,
    Wrapped<UserAudioEntity?>? payloadUserAudio,
  }) {
    return DownloadedTaskEntity(
      id: id?.value ?? this.id,
      userId: userId?.value ?? this.userId,
      savePath: savePath?.value ?? this.savePath,
      fileType: fileType?.value ?? this.fileType,
      payloadUserAudioId: payloadUserAudioId?.value ?? this.payloadUserAudioId,
      payloadUserAudio: payloadUserAudio?.value ?? this.payloadUserAudio,
    );
  }
}
