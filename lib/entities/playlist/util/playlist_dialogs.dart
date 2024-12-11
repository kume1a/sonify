import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../ui/mutate_playlist_dialog.dart';

@lazySingleton
class PlaylistDialogs {
  Future<void> showMutatePlaylistDialog() {
    return GlobalNavigator.dialog(const MutatePlaylistDialog());
  }
}
