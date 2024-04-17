import 'package:common_models/common_models.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../model/local_music.dart';
import '../util/local_music_mapper.dart';
import 'query_local_music.dart';

@LazySingleton(as: QueryLocalMusic)
class QueryLocalMusicImpl implements QueryLocalMusic {
  QueryLocalMusicImpl(
    this._audioQuery,
    this._localMusicMapper,
  );

  final OnAudioQuery _audioQuery;
  final LocalMusicMapper _localMusicMapper;

  @override
  Future<Either<NetworkCallError, List<LocalMusic>>> call() async {
    try {
      final musicModels = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );

      final localMusicList = musicModels.map(_localMusicMapper.songModelToLocalMusic).toList();

      return right(localMusicList);
    } catch (e) {
      Logger.root.severe('Error querying local music: $e');
    }

    return left(NetworkCallError.unknown);
  }
}
