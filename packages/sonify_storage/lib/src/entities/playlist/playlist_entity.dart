import '../../shared/wrapped.dart';

class PlaylistEntity {
  PlaylistEntity({
    required this.id,
    required this.createdAtMillis,
    required this.name,
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.spotifyId,
    required this.audioImportStatus,
    required this.audioCount,
    required this.totalAudioCount,
  });

  final String? id;
  final int? createdAtMillis;
  final String? name;
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String? spotifyId;
  final String? audioImportStatus;
  final int? audioCount;
  final int? totalAudioCount;

  PlaylistEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? name,
    Wrapped<String?>? thumbnailPath,
    Wrapped<String?>? thumbnailUrl,
    Wrapped<String?>? spotifyId,
    Wrapped<String?>? audioImportStatus,
    Wrapped<int?>? audioCount,
    Wrapped<int?>? totalAudioCount,
  }) {
    return PlaylistEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      name: name?.value ?? this.name,
      thumbnailPath: thumbnailPath?.value ?? this.thumbnailPath,
      thumbnailUrl: thumbnailUrl?.value ?? this.thumbnailUrl,
      spotifyId: spotifyId?.value ?? this.spotifyId,
      audioImportStatus: audioImportStatus?.value ?? this.audioImportStatus,
      audioCount: audioCount?.value ?? this.audioCount,
      totalAudioCount: totalAudioCount?.value ?? this.totalAudioCount,
    );
  }
}
