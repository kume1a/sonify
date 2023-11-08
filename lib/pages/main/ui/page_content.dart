import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../jiosaavn_page.dart';
import '../../library_page.dart';
import '../../profile_page.dart';
import '../../youtube_page.dart';
import '../state/main_page_state.dart';

class PageContent extends StatelessWidget {
  const PageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainPageState>(
      buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
      builder: (_, state) {
        return IndexedStack(
          index: state.pageIndex,
          children: const [
            LibraryPage(),
            YoutubePage(),
            JiosaavnPage(),
            ProfilePage(),
          ],
        );
      },
    );
  }
}
