import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../features/auth/state/sign_out_state.dart';
import '../../../features/dynamic_client/state/change_server_url_origin_state.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../../../shared/util/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../../playlist/state/import_spotify_playlists_state.dart';
import '../state/profile_tiles_state.dart';

class DownloadsTile extends StatelessWidget {
  const DownloadsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgDownload,
      label: l.downloads,
      onPressed: context.profileTilesCubit.onDownloadsTilePressed,
    );
  }
}

class PreferencesTile extends StatelessWidget {
  const PreferencesTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgGear,
      label: l.preferences,
      onPressed: context.profileTilesCubit.onPreferencesTilePressed,
    );
  }
}

class ImportLocalAudioFilesTile extends StatelessWidget {
  const ImportLocalAudioFilesTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgImport,
      label: l.importLocalAudioFiles,
      onPressed: context.profileTilesCubit.onImportLocalAudioFilesTilePressed,
    );
  }
}

class ImporSpotifyPlaylistsTile extends StatelessWidget {
  const ImporSpotifyPlaylistsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<ImportSpotifyPlaylistsCubit, ImportSpotifyPlaylistsState>(
      buildWhen: (previous, current) =>
          previous.importSpotifyPlaylistsState != current.importSpotifyPlaylistsState,
      builder: (_, state) {
        return _ProfileTile(
          iconAssetName: Assets.svgImport,
          label: l.importSpotifyPlaylists,
          onPressed: state.importSpotifyPlaylistsState.whenOrNull(
            idle: () => context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
            failed: (_) => context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
          ),
          end: state.importSpotifyPlaylistsState.whenOrNull(
            executing: () => const SmallCircularProgressIndicator(),
            failed: (err) => Icon(Icons.error, color: theme.colorScheme.error),
            executed: () => Icon(Icons.check, color: theme.appThemeExtension?.success),
          ),
        );
      },
    );
  }
}

class ChangeServerUrlOriginTile extends StatelessWidget {
  const ChangeServerUrlOriginTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgServer,
      label: l.changeServerUrlOrigin,
      onPressed: context.changeServerUrlOriginCubit.onChangeServerUrlOriginTilePressed,
    );
  }
}

class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgSignOut,
      label: l.signOut,
      onPressed: context.signOutCubit.onSignOutPressed,
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.iconAssetName,
    required this.label,
    required this.onPressed,
    this.end,
  });

  final String iconAssetName;
  final String label;
  final VoidCallback? onPressed;
  final Widget? end;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(
              iconAssetName,
              width: 16,
              height: 16,
              colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            if (end != null) end!,
          ],
        ),
      ),
    );
  }
}
