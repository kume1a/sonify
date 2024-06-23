import 'package:domain_data/domain_data.dart';

final dummyAudioNames = [
  'Accordion',
  'Acoustic Guitar',
  'Banjo',
  'Bass Drum',
  'Cello',
  'Clapping',
  'Djembe',
  'Drum Set',
  'Electric Guitar',
  'Euphonium',
  'Fiddle',
  'Flute',
  'Glockenspiel',
  'Gong',
  'Harp',
  'Harmonica',
  'Indian Flute',
  'Irish Flute',
  'Jaw Harp',
  'Jazz Piano',
  'Kalimba',
  'Keyboard',
  'Lap Steel Guitar',
  'Lute',
  'Mandolin',
  'Maracas',
  'Ney',
  'Nylon Guitar',
  'Oboe',
  'Ocarina',
  'Percussion',
  'Piano',
  'Quartet',
  'Quena',
  'Recorder',
  'Rhythm Guitar',
  'Saxophone',
  'Sitar',
];

final dummyUserAudios = dummyAudioNames
    .map(
      (e) => Audio(
        id: e.hashCode.toString(),
        title: e,
        durationMs: 0, // Replace 0 with the actual duration in milliseconds
        path: '1234', // Replace '' with the actual path of the audio file
        localPath: '1234', // Replace '' with the actual local path of the audio file
        author: 'Artist', // Replace '' with the actual author of the audio
        sizeBytes: 100, // Replace 0 with the actual size of the audio file in bytes
        youtubeVideoId: '21', // Replace '' with the actual YouTube video ID if applicable
        spotifyId: '', // Replace '' with the actual Spotify ID if applicable
        thumbnailPath: '', // Replace '' with the actual path of the thumbnail image
        thumbnailUrl: '', // Replace '' with the actual URL of the thumbnail image
        localThumbnailPath: '', // Replace '' with the actual local path of the thumbnail image
        audioLike: null,
        createdAt: DateTime.now(), // Replace null with the actual AudioLike object if applicable
      ),
    )
    .toList();
