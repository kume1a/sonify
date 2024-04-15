import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';

extension ProfileTilesCubitX on BuildContext {
  ProfileTilesCubit get profileTilesCubit => read<ProfileTilesCubit>();
}

@injectable
class ProfileTilesCubit extends Cubit<Unit> {
  ProfileTilesCubit(
    this._pageNavigator,
  ) : super(unit);

  final PageNavigator _pageNavigator;

  void onDownloadsTilePressed() {}

  void onSettingsTilePressed() {}
}
