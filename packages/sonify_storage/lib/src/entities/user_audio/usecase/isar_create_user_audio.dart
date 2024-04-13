import '../../../../sonify_storage.dart';

class IsarCreateUserAudioWithAudio implements CreateUserAudioWithAudio {
  IsarCreateUserAudioWithAudio(
    this._isar,
  );

  final Isar _isar;

  @override
  Future<UserAudioAndAudioEntityIds> call({
    required UserAudioEntity userAudio,
    required AudioEntity audio,
  }) {
    userAudio.audio.value = audio;

    return _isar.writeTxn(() async {
      final userAudioId = await _isar.collection<UserAudioEntity>().put(userAudio);
      final audioId = await _isar.collection<AudioEntity>().put(audio);

      await userAudio.audio.save();

      return UserAudioAndAudioEntityIds(
        userAudioEntityId: userAudioId,
        audioEntityId: audioId,
      );
    });
  }
}
