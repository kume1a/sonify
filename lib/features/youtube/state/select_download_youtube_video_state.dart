import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../app/navigation/page_navigator.dart';

part 'select_download_youtube_video_state.freezed.dart';

@freezed
class SelectDownloadYoutubeVideoState with _$SelectDownloadYoutubeVideoState {
  const factory SelectDownloadYoutubeVideoState({
    AudioOnlyStreamInfo? selectedStreamInfo,
  }) = _SelectDownloadYoutubeVideoState;

  factory SelectDownloadYoutubeVideoState.initial() => const SelectDownloadYoutubeVideoState();
}

extension DownloadYoutubeVideoCubitX on BuildContext {
  SelectDownloadYoutubeVideoCubit get selectDownloadYoutubeVideoCubit =>
      read<SelectDownloadYoutubeVideoCubit>();
}

@injectable
class SelectDownloadYoutubeVideoCubit extends Cubit<SelectDownloadYoutubeVideoState> {
  SelectDownloadYoutubeVideoCubit(
    this._pageNavigator,
  ) : super(SelectDownloadYoutubeVideoState.initial());

  final PageNavigator _pageNavigator;

  void onChangeSelectedStreamInfo(AudioOnlyStreamInfo audioOnlyStreamInfo) {
    emit(state.copyWith(selectedStreamInfo: audioOnlyStreamInfo));
  }

  void onDownloadPressed() {
    if (state.selectedStreamInfo == null) {
      return;
    }

    _pageNavigator.pop(result: state.selectedStreamInfo);
  }
}
