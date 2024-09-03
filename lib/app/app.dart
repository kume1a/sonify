import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:toastification/toastification.dart';

import '../features/download_file/state/downloads_state.dart';
import '../features/dynamic_client/state/change_server_url_origin_state.dart';
import '../features/play_audio/state/audio_player_controls_state.dart';
import '../features/play_audio/state/now_playing_audio_state.dart';
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
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<DownloadsCubit>(), lazy: false),
            BlocProvider(create: (_) => getIt<AudioPlayerControlsCubit>()),
            BlocProvider(create: (_) => getIt<NowPlayingAudioCubit>()),
            BlocProvider(create: (_) => getIt<ChangeServerUrlOriginCubit>()),
          ],
          child: ToastificationWrapper(
            config: const ToastificationConfig(
              animationDuration: Duration(milliseconds: 400),
              alignment: Alignment.bottomCenter,
            ),
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
          ),
        );
      },
    );
  }
}
