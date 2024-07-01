import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../features/search/state/search_my_library_state.dart';
import '../features/search/ui/searched_my_library_list.dart';
import '../shared/ui/search_input_with_cancel.dart';

class MyLibrarySearchPage extends StatelessWidget {
  const MyLibrarySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SearchMyLibraryCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return TapOutsideToClearFocus(
      child: Scaffold(
        body: SafeArea(
          child: AudioPlayerPanel(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: SearchInputWithCancel(
                    onChanged: context.searchMyLibraryCubit.onSearchQueryChanged,
                    onCancelPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const Expanded(
                  child: SearchedMyLibraryList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
