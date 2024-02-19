import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_navigator/global_navigator.dart';

import '../features/download_file/state/downloads_state.dart';
import '../shared/values/app_theme.dart';
import 'di/register_dependencies.dart';
import 'intl/app_localizations.dart';
import 'navigation/page_navigator.dart';
import 'navigation/route_factory.dart';
import 'navigation/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

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
}
