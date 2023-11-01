import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../api/youtube_api.dart';
import '../model/youtube_music_home_dto.dart';

typedef YoutubeHomeVideosState = DataState<FetchFailure, YoutubeMusicHomeDto>;

extension YoutubeHomeVideosCubitX on BuildContext {
  YoutubeHomeVideosCubit get youtubeHomeVideosCubit => read<YoutubeHomeVideosCubit>();
}

@injectable
class YoutubeHomeVideosCubit extends Cubit<DataState<FetchFailure, YoutubeMusicHomeDto>> {
  YoutubeHomeVideosCubit(
    this._youtubeApi,
    this._pageNavigator,
  ) : super(DataState.idle()) {
    _init();
  }

  final YoutubeApi _youtubeApi;
  final PageNavigator _pageNavigator;

  Future<void> _init() async {
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    emit(DataState.loading());
    final res = await _youtubeApi.getMusicHome();
    emit(DataState.fromEither(res));
  }

  void onSearchPressed() {
    _pageNavigator.toYoutubeSearch();
  }
}
