// import 'dart:typed_data';

// import 'package:injectable/injectable.dart';
// import 'package:logging/logging.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// import 'query_local_music_artwork.dart';

// @LazySingleton(as: QueryLocalMusicArtwork)
// class QueryLocalMusicArtworkImpl implements QueryLocalMusicArtwork {
//   QueryLocalMusicArtworkImpl(this._audioQuery);

//   final OnAudioQuery _audioQuery;

//   @override
//   Future<Uint8List?> call({
//     required int localMusicId,
//   }) {
//     try {
//       return _audioQuery.queryArtwork(
//         localMusicId,
//         ArtworkType.AUDIO,
//         size: 200,
//         format: ArtworkFormat.PNG,
//       );
//     } catch (e) {
//       Logger.root.severe('Error querying local music artwork: $e');
//     }

//     return Future.value();
//   }
// }
