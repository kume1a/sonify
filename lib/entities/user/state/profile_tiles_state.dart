import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../features/dynamic_client/model/server_url_origin.dart';
import '../../../features/dynamic_client/util/server_url_origin_store.dart';
import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';

extension ProfileTilesCubitX on BuildContext {
  ProfileTilesCubit get profileTilesCubit => read<ProfileTilesCubit>();
}

@injectable
class ProfileTilesCubit extends Cubit<Unit> {
  ProfileTilesCubit(
    this._pageNavigator,
    this._bottomSheetManager,
    this._serverUrlOriginStore,
  ) : super(unit);

  final PageNavigator _pageNavigator;
  final BottomSheetManager _bottomSheetManager;
  final ServerUrlOriginStore _serverUrlOriginStore;

  void onDownloadsTilePressed() {
    _pageNavigator.toDownloads();
  }

  void onSettingsTilePressed() {}

  void onImportLocalAudioFilesTilePressed() {
    _pageNavigator.toImportLocalMusic();
  }

  Future<void> onChangeServerUrlOriginTilePressed() async {
    final selectedOption = await _bottomSheetManager.openOptionSelector(
      header: (l) => l.selectServerUrlOrigin,
      options: [
        SelectOption(
          label: (l) => l.local,
          value: ServerUrlOrigin.local,
        ),
        SelectOption(
          label: (l) => l.remote,
          value: ServerUrlOrigin.remote,
        ),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    final currentOption = _serverUrlOriginStore.read();

    if (currentOption == selectedOption) {
      return;
    }

    await _serverUrlOriginStore.write(selectedOption);
  }
}
