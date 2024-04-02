import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:logging/logging.dart';

import '../features/download_file/state/downloads_state.dart';
import '../shared/values/app_theme.dart';
import 'di/register_dependencies.dart';
import 'intl/app_localizations.dart';
import 'navigation/page_navigator.dart';
import 'navigation/route_factory.dart';
import 'navigation/routes.dart';
import 'package:app_links/app_links.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppLinks _appLinks;

  StreamSubscription<Uri>? _linkSubscription;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DownloadsCubit>(), lazy: false),
      ],
      child: MaterialApp(
        title: 'Sonify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: Routes.root,
        navigatorObservers: [GNObserver()],
        onGenerateRoute: routeFactory,
        navigatorKey: navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    Logger.root.info('Dispose called');

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      Logger.root.info('getInitialAppLink: $appLink');
      // openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)

    Logger.root.info('Listening to app links');
    _linkSubscription = _appLinks.allUriLinkStream.listen((uri) {
      Logger.root.info('onAppLink: $uri');
      Logger.root.info('Fragment: ${uri.fragment}');
      Logger.root.info('Path: ${uri.path}');
      Logger.root.info('Query: ${uri.queryParameters}');
      // openAppLink(uri);
    });
  }

  // void openAppLink(Uri uri) {
  //   navigatorKey.currentState?.pushNamed(uri.fragment);
  // }
}
