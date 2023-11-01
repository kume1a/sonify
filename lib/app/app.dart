import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';

import '../pages/main/main_page.dart';
import '../shared/values/app_theme.dart';
import 'navigation/page_navigator.dart';
import 'navigation/route_factory.dart';
import 'navigation/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainPage(),
      initialRoute: Routes.root,
      navigatorObservers: [GNObserver()],
      onGenerateRoute: routeFactory,
      navigatorKey: navigatorKey,
    );
  }
}
