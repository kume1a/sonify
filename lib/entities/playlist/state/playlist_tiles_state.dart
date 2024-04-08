import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';

extension PlaylistTilesCubitX on BuildContext {
  PlaylistTilesCubit get playlistTilesCubit => read<PlaylistTilesCubit>();
}

@injectable
class PlaylistTilesCubit extends Cubit<Unit> {
  PlaylistTilesCubit(
    this._pageNavigator,
  ) : super(unit);

  final PageNavigator _pageNavigator;

  void onMyLibraryPressed() {
    _pageNavigator.toMyLibrary();
  }

  void onLikedSongsPressed() {}
}
