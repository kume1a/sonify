import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/thumbnail.dart';
import '../../../shared/util/equality.dart';
import '../../../shared/util/utils.dart';
import '../../../shared/values/app_theme_extension.dart';
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.importLocalMusicCubit.onMusicSelectToggled(localMusic),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            QueryArtworkWidget(
              id: localMusic.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(8),
              artworkWidth: 42,
              artworkHeight: 42,
              nullArtworkWidget: const ThumbnailPlaceholder(
                size: Size.square(42),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localMusic.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (localMusic.artist.notNullOrEmpty)
                    Text(
                      localMusic.artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.appThemeExtension?.elSecondary,
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<ImportLocalMusicCubit, ImportLocalMusicState>(
              buildWhen: (previous, current) => notDeepEquals(previous.selectedIds, current.selectedIds),
              builder: (_, state) {
                final isSelected = state.selectedIds.contains(localMusic.id);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: isSelected
                        ? null
                        : Border.all(color: theme.appThemeExtension?.elSecondary ?? Colors.transparent),
                    shape: BoxShape.circle,
                    color: isSelected ? theme.colorScheme.secondary : null,
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 12) : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
