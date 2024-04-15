import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../model/local_music.dart';
import '../state/import_local_music_state.dart';

class ImportedLocalMusicList extends StatelessWidget {
  const ImportedLocalMusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EnsureAudioPermissionGranted(
      child: _LocalMusicList(),
    );
  }
}

class _EnsureAudioPermissionGranted extends StatelessWidget {
  const _EnsureAudioPermissionGranted({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<ImportLocalMusicCubit, ImportLocalMusicState>(
      buildWhen: (previous, current) => previous.isAudioPermissionGranted != current.isAudioPermissionGranted,
      builder: (_, state) {
        return state.isAudioPermissionGranted.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (isGranted) => isGranted
              ? child
              : Center(
                  child: Column(
                    children: [
                      Text(
                        l.allowAudioPermissionForLocalMusic,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: context.importLocalMusicCubit.onGrantAudioPermissionPressed,
                        child: Text(l.grant),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _LocalMusicList extends StatelessWidget {
  const _LocalMusicList();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<ImportLocalMusicCubit, ImportLocalMusicState>(
      buildWhen: (previous, current) => previous.localMusic != current.localMusic,
      builder: (_, state) {
        return state.localMusic.when(
          idle: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (_) => Center(child: Text(l.failedToImportLocalMusic)),
          success: (localMusic) => ListView.builder(
            itemCount: localMusic.length,
            itemBuilder: (_, index) => _Item(localMusic: localMusic[index]),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.localMusic,
  });

  final LocalMusic localMusic;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(localMusic.title),
      subtitle: Text(localMusic.artist ?? ''),
      onTap: () {},
    );
  }
}