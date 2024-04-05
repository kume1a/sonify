import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../pages/playlist_page.dart';
import '../../pages/youtube_video_page.dart';
import 'routes.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

@lazySingleton
class PageNavigator {
  void pop<T>({T? result}) => GlobalNavigator.maybePop(result: result);

  void toMain() => GlobalNavigator.pushNamedAndRemoveAll(Routes.main);

  Future<YoutubeSearchResult?> toYoutubeSearch() async {
    final dynamic result = await GlobalNavigator.pushNamed(Routes.youtubeSearch);

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
}
