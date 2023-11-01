import 'package:flutter/widgets.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';

import '../../features/youtube/model/youtube_search_result.dart';
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
}
