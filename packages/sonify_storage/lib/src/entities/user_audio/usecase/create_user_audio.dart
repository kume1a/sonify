import '../../../../sonify_storage.dart';

class UserAudioAndAudioEntityIds {
  UserAudioAndAudioEntityIds({
    required this.userAudioEntityId,
    required this.audioEntityId,
  });

  final int userAudioEntityId;
  final int audioEntityId;
}

abstract interface class CreateUserAudioWithAudio {
  Future<UserAudioAndAudioEntityIds> call({
    required UserAudioEntity userAudio,
    required AudioEntity audio,
  });
}
