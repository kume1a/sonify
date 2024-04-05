import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/playlist/state/playlist_state.dart';

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
    return BlocProvider(
      create: (_) => getIt<PlaylistCubit>()..init(args.playlistId),
      lazy: false,
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
