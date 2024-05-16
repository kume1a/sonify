import '../../shared/wrapped.dart';

class PlaylistEntity {
  PlaylistEntity({
    required this.id,
    required this.createdAtMillis,
    required this.name,
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.spotifyId,
  });

  final String? id;
  final int? createdAtMillis;
  final String? name;
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final String? spotifyId;

  PlaylistEntity copyWith({
    Wrapped<String?>? id,
    Wrapped<int?>? createdAtMillis,
    Wrapped<String?>? name,
    Wrapped<String?>? thumbnailPath,
    Wrapped<String?>? thumbnailUrl,
    Wrapped<String?>? spotifyId,
  }) {
    return PlaylistEntity(
      id: id?.value ?? this.id,
      createdAtMillis: createdAtMillis?.value ?? this.createdAtMillis,
      name: name?.value ?? this.name,
      thumbnailPath: thumbnailPath?.value ?? this.thumbnailPath,
      thumbnailUrl: thumbnailUrl?.value ?? this.thumbnailUrl,
      spotifyId: spotifyId?.value ?? this.spotifyId,
    );
  }
}
