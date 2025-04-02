import 'package:domain_data/domain_data.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../../entities/playlist/ui/playlist_selector_sheet.dart';
import '../typedefs.dart';
import 'select_option/select_option.dart';
import 'select_option/select_option_bs.dart';

@lazySingleton
class BottomSheetManager {
  Future<T?> openOptionSelector<T extends Object?>({
    required LocalizedStringResolver header,
    required List<SelectOption<T>> options,
  }) async {
    return GlobalNavigator.bottomSheet(SelectOptionSelectorBS<T>(
      header: header,
      options: options,
    ));
  }
}
