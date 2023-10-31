import 'package:flutter/material.dart';

import '../pages/main/main_page.dart';
import '../shared/values/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainPage(),
    );
  }
}
