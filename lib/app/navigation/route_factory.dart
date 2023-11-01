import 'package:flutter/material.dart';
import '../../pages/main/main_page.dart';
import '../../pages/youtube_search_page.dart';
import 'routes.dart';

Route<dynamic> routeFactory(RouteSettings settings) {
  return switch (settings.name) {
    Routes.root => _createMainRoute(settings),
    Routes.main => _createMainRoute(settings),
    Routes.youtubeSearch => _createYoutubeSearchRoute(settings),
    _ => throw Exception('route ${settings.name} is not supported'),
  };
}

Route<dynamic> _createYoutubeSearchRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const YoutubeSearchPage(),
    settings: settings,
  );
}

Route<dynamic> _createMainRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const MainPage(),
    settings: settings,
  );
}
