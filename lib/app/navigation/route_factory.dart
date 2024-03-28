import 'package:flutter/material.dart';
import '../../pages/auth_page.dart';
import '../../pages/email_sign_in_page.dart';
import '../../pages/main/main_page.dart';
import '../../pages/user_name_page.dart';
import '../../pages/youtube_search_page.dart';
import '../../pages/youtube_video_page.dart';
import 'routes.dart';

Route<dynamic> routeFactory(RouteSettings settings) {
  return switch (settings.name) {
    Routes.root => _createAuthRoute(settings),
    Routes.main => _createMainRoute(settings),
    Routes.youtubeSearch => _createYoutubeSearchRoute(settings),
    Routes.youtubeVideo => _createYoutubeVideoRoute(settings),
    Routes.userName => _createUserNameRoute(settings),
    Routes.auth => _createAuthRoute(settings),
    Routes.emailSignIn => _createEmailSignInRoute(settings),
    _ => throw Exception('route ${settings.name} is not supported'),
  };
}

Route _createEmailSignInRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const EmailSignInPage(),
    settings: settings,
  );
}

Route _createUserNameRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const UserNamePage(),
    settings: settings,
  );
}

Route _createAuthRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const AuthPage(),
    settings: settings,
  );
}

Route _createYoutubeVideoRoute(RouteSettings settings) {
  final YoutubeVideoPageArgs args = _getArgs(settings);

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

T _getArgs<T>(RouteSettings settings) {
  if (settings.arguments == null || settings.arguments is! T) {
    throw Exception('Arguments typeof ${T.runtimeType} is required');
  }

  return settings.arguments as T;
}
