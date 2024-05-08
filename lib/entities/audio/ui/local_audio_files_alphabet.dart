import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/ui/alphabet_list.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFilesAlphabet extends StatelessWidget {
  const LocalAudioFilesAlphabet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const Center(child: SmallCircularProgressIndicator()),
          success: (data) => AlphabetList(
            keywords: data.map((e) => e.title).toList(),
            backgroundColor: theme.colorScheme.primaryContainer,
            onIndexChanged: (value) {},
            padding: const EdgeInsets.symmetric(vertical: 16),
            margin: const EdgeInsets.only(top: 12, bottom: 90),
            textStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
              color: theme.appThemeExtension?.elSecondary,
            ),
            overlayWidgetBuilder: (value) => Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                value.toUpperCase(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
