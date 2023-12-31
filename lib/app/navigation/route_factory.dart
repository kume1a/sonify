import 'package:flutter/material.dart';
import '../../pages/main/main_page.dart';
import '../../pages/youtube_search_page.dart';
import '../../pages/youtube_video_page.dart';
import 'routes.dart';

Route<dynamic> routeFactory(RouteSettings settings) {
  return switch (settings.name) {
    Routes.root => _createMainRoute(settings),
    Routes.main => _createMainRoute(settings),
    Routes.youtubeSearch => _createYoutubeSearchRoute(settings),
    Routes.youtubeVideo => _createYoutubeVideoRoute(settings),
    _ => throw Exception('route ${settings.name} is not supported'),
  };
}

Route _createYoutubeVideoRoute(RouteSettings settings) {
  if (settings.arguments == null || settings.arguments is! YoutubeVideoPageArgs) {
    throw Exception('args type of $YoutubeVideoPageArgs is required');
  }

  final args = settings.arguments! as YoutubeVideoPageArgs;

  return MaterialPageRoute(
    builder: (_) => YoutubeVideoPage(args: args),
    settings: settings,
  );
}

Route _createYoutubeSearchRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const YoutubeSearchPage(),
    settings: settings,
  );
}

Route _createMainRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const MainPage(),
    settings: settings,
  );
}
