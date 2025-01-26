import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../../pages/playlist_page.dart';
import '../../pages/search_playlist_audios_page.dart';
import '../../pages/search_suggestions_page.dart';
import '../../pages/youtube_video_page.dart';
import 'routes.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

@lazySingleton
class PageNavigator {
  void pop<T>({T? result}) => GlobalNavigator.maybePop(result: result);

  void toMain() => GlobalNavigator.pushNamedAndRemoveAll(Routes.main);

  Future<YoutubeSearchResult?> toSearchSuggestions(SearchSuggestionsPageArgs args) async {
    final dynamic result = await GlobalNavigator.pushNamed(
      Routes.searchSuggestions,
      arguments: args,
    );

    if (result is YoutubeSearchResult) {
      return result;
    }

    return null;
  }

  void toYoutubeVideo(YoutubeVideoPageArgs args) =>
      GlobalNavigator.pushNamed(Routes.youtubeVideo, arguments: args);

  void toUserName() => GlobalNavigator.pushNamedAndRemoveAll(Routes.userName);

  void toAuth() => GlobalNavigator.pushNamedAndRemoveAll(Routes.auth);

  void toEmailSignIn() => GlobalNavigator.pushNamed(Routes.emailSignIn);

  void toPlaylist(PlaylistPageArgs args) => GlobalNavigator.pushNamed(Routes.playlist, arguments: args);

  void toMyLibrary() => GlobalNavigator.pushNamed(Routes.myLibrary);

  void toImportLocalMusic() => GlobalNavigator.pushNamed(Routes.importLocalMusic);

  void toDownloads() => GlobalNavigator.pushNamed(Routes.downloads);

  void toMyLibrarySearch() => GlobalNavigator.pushNamed(Routes.myLibrarySearch);

  void toSearchPlaylistAudios(SearchPlaylistAudiosPageArgs args) =>
      GlobalNavigator.pushNamed(Routes.searchPlaylistAudios, arguments: args);

  void toPreferences() => GlobalNavigator.pushNamed(Routes.preferences);

  void popTillMain() {
    GlobalNavigator.popUntil((route) => route.settings.name == Routes.main);
  }
}
