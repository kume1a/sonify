import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/playlist/state/playlist_state.dart';
import '../entities/playlist/ui/playlist_appbar.dart';
import '../entities/playlist/ui/playlist_items.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/state/audio_player_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';

class PlaylistPageArgs {
  const PlaylistPageArgs({
    required this.playlistId,
  });

  final String playlistId;
}

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({
    super.key,
    required this.args,
  });

  final PlaylistPageArgs args;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PlaylistCubit>()..init(args.playlistId),
        ),
        BlocProvider(create: (_) => getIt<AudioPlayerCubit>()),
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
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: AudioPlayerPanel(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: PlaylistAppBar(
                maxExtent: mediaQuery.padding.top + mediaQuery.size.height * .35,
                minExtent: mediaQuery.padding.top + 56,
              ),
            ),
            const SliverSizedBox(height: 42),
            const PlaylistItems(),
          ],
        ),
      ),
    );
  }
}
