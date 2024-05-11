import '../../db/db_batch.dart';

import 'playlist_audio_entity.dart';

class BAudioIdAndBPlaylistId {
  BAudioIdAndBPlaylistId({
    required this.bAudioId,
    required this.bPlaylistId,
  });

  final String bAudioId;
  final String bPlaylistId;
}

abstract interface class PlaylistAudioEntityDao {
  void batchCreate(
    PlaylistAudioEntity playlist, {
    required DbBatchProvider batchProvider,
  });

  Future<void> deleteMany(List<BAudioIdAndBPlaylistId> ids);

  Future<List<BAudioIdAndBPlaylistId>> getAllBIds();
}
