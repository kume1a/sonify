import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../api/youtube_api.dart';
import '../model/youtube_music_home_dto.dart';

typedef YoutubeHomeVideosState = DataState<FetchFailure, YoutubeMusicHomeDto>;

@injectable
class YoutubeHomeVideosCubit extends Cubit<DataState<FetchFailure, YoutubeMusicHomeDto>> {
  YoutubeHomeVideosCubit(
    this._youtubeApi,
  ) : super(DataState.idle()) {
    _init();
  }

  final YoutubeApi _youtubeApi;

  Future<void> _init() async {
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    emit(DataState.loading());
    final res = await _youtubeApi.getMusicHome();
    emit(DataState.fromEither(res));
  }
}
