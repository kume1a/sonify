import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/ui/alphabet_list.dart';
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
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          success: (data) => AlphabetList(
            keywords: data.map((e) => e.title).toList(),
            itemExtent: 60,
            backgroundColor: theme.colorScheme.primaryContainer,
            onIndexChanged: (value) {},
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
