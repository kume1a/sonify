import 'package:common_models/common_models.dart';
import 'package:injectable/injectable.dart';

import '../model/local_music.dart';
import 'query_local_music.dart';

@LazySingleton(as: QueryLocalMusic)
class NoopQueryLocalMusicImpl implements QueryLocalMusic {
  NoopQueryLocalMusicImpl();

  @override
  Future<Either<NetworkCallError, List<LocalMusic>>> call() async {
    throw UnimplementedError('NoopQueryLocalMusicImpl is not implemented');
  }
}
