import 'package:domain_data/domain_data.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../ui/mutate_playlist_dialog.dart';
import '../ui/playlist_selector_sheet.dart';

@lazySingleton
class PlaylistPopups {
  Future<void> showMutatePlaylistDialog({
    String? userPlaylistId,
  }) {
    return GlobalNavigator.dialog(MutatePlaylistDialog(userPlaylistId: userPlaylistId));
  }

  Future<Playlist?> openPlaylistSelector() async {
    return GlobalNavigator.bottomSheet(const PlaylistSelectorSheet());
  }
}
