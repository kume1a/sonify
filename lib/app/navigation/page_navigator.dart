import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:sonify_client/sonify_client.dart';

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

  void toUserName() => GlobalNavigator.pushReplacementNamed(Routes.userName);

  void toAudioPlayer() => GlobalNavigator.pushNamed(Routes.audioPlayer);

  void toAuthPage() => GlobalNavigator.pushNamedAndRemoveAll(Routes.auth);
}
