import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/animation/infinite_rotation.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/assets.dart';
import '../state/sync_user_data_state.dart';

class SyncUserDataIndicator extends StatelessWidget {
  const SyncUserDataIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<SyncUserDataCubit, SyncUserDataState>(
      buildWhen: (previous, current) =>
          previous.syncState != current.syncState ||
          previous.queuedDownloadsCount != current.queuedDownloadsCount,
      builder: (_, state) {
        return switch (state.syncState) {
          SyncAudiosState.idle => const SizedBox.shrink(),
          SyncAudiosState.loading => _SyncContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InfiniteRotation(
                    duration: const Duration(seconds: 1, milliseconds: 500),
                    child: SvgPicture.asset(
                      Assets.svgSync,
                      width: 18,
                      height: 18,
                      colorFilter: svgColor(theme.colorScheme.onSecondary),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(l.syncingAudio),
                ],
              ),
            ),
          SyncAudiosState.loaded => TextButton(
              onPressed: context.syncUserAudioCubit.onSeeDownloadsPressed,
              child: Text(l.seeDownloads),
            ),
          SyncAudiosState.error => _SyncContainer(
              child: Text(l.syncFailed),
            ),
          SyncAudiosState.nothingToSync => _SyncContainer(
              child: Text(l.nothingToSync),
            ),
        };
      },
    );
  }
}

class _SyncContainer extends StatelessWidget {
  const _SyncContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.secondary,
      ),
      child: child,
    );
  }
}
