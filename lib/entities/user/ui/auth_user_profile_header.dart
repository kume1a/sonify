import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../state/auth_user_state.dart';

class AuthUserProfileHeader extends StatelessWidget {
  const AuthUserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16, mediaQuery.size.height * .1, 16, 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imageBlackMetalWall),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocBuilder<AuthUserCubit, AuthUserState>(
        builder: (_, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            success: (data) => Row(
              children: [
                CircleAvatar(
                  radius: 22.5,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Align(
                    child: SvgPicture.asset(
                      Assets.svgUser,
                      width: 16,
                      height: 16,
                      colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
