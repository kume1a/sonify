import 'package:freezed_annotation/freezed_annotation.dart';

import '../../audiolike/model/audio_like.dart';
import '../../hidden_user_audio/model/hidden_user_audio.dart';

part 'audio.freezed.dart';

@freezed
class Audio with _$Audio {
  const factory Audio({
    required String? id,
    required DateTime? createdAt,
    required String title,
    required int durationMs,
    required String path,
    required String? localPath,
    required String author,
    required int sizeBytes,
    required String? youtubeVideoId,
    required String? spotifyId,
    required String? thumbnailPath,
    required String? thumbnailUrl,
    required String? localThumbnailPath,
    required AudioLike? audioLike,
    required HiddenUserAudio? hiddenUserAudio,
  }) = _Audio;

  const Audio._();

  bool get isLiked => audioLike != null;

  bool get isHidden => hiddenUserAudio != null;
}
