import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../entities/audio/state/local_audio_files_state.dart';
import '../entities/audio/ui/local_audio_files.dart';
import '../entities/playlist/ui/my_library_header.dart';
import '../entities/playlist/ui/my_library_tiles.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocalAudioFilesCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: padding.copyWith(top: 20),
              child: TextField(
                autocorrect: false,
                onChanged: context.localAudioFilesCubit.onSearchQueryChanged,
                decoration: InputDecoration(
                  hintText: l.search,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: padding,
                    sliver: SliverToBoxAdapter(
                      child: MyLibraryTiles(),
                    ),
                  ),
                  SliverSizedBox(height: 20),
                  SliverPadding(
                    padding: padding,
                    sliver: SliverToBoxAdapter(
                      child: MyLibraryHeader(),
                    ),
                  ),
                  SliverSizedBox(height: 16),
                  LocalAudioFiles(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
