import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';
import '../model/server_url_origin.dart';
import '../util/server_url_origin_store.dart';

extension ChangeServerUrlOriginCubitX on BuildContext {
  ChangeServerUrlOriginCubit get changeServerUrlOriginCubit => read<ChangeServerUrlOriginCubit>();
}

@injectable
class ChangeServerUrlOriginCubit extends Cubit<Unit> {
  ChangeServerUrlOriginCubit(
    this._serverUrlOriginStore,
    this._bottomSheetManager,
  ) : super(unit);

  final ServerUrlOriginStore _serverUrlOriginStore;
  final BottomSheetManager _bottomSheetManager;

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
