import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/util/color.dart';
import '../../../shared/values/assets.dart';
import '../state/main_page_state.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainPageState>(
      buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
      builder: (_, state) {
        return BottomNavigationBar(
          showUnselectedLabels: true,
          onTap: context.mainPageCubit.onPageChanged,
          currentIndex: state.pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svgLibrary,
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                Assets.svgLibrary,
                width: 24,
                height: 24,
                colorFilter: svgColor(Colors.white),
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svgYoutube,
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                Assets.svgYoutube,
                width: 24,
                height: 24,
                colorFilter: svgColor(Colors.white),
              ),
              label: 'Youtube',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svgUser,
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                Assets.svgUser,
                width: 24,
                height: 24,
                colorFilter: svgColor(Colors.white),
              ),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
