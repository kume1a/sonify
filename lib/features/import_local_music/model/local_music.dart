class LocalMusic {
  LocalMusic({
    required this.id,
    required this.data,
    required this.uri,
    required this.displayName,
    required this.displayNameWOExt,
    required this.size,
    required this.album,
    required this.artist,
    required this.genre,
    required this.composer,
    required this.dateAdded,
    required this.dateModified,
    required this.duration,
    required this.title,
    required this.track,
  });

  final int id;
  final String data;
  final String? uri;
  final String displayName;
  final String displayNameWOExt;
  final int size;
  final String? album;
  final String? artist;
  final String? genre;
  final String? composer;
  final int? dateAdded;
  final int? dateModified;
  final int? duration;
  final String title;
  final int? track;
}
