import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../features/auth/state/sign_out_state.dart';
import '../../../features/sync_user_data/state/sync_user_data_state.dart';
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

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgGear,
      label: l.settings,
      onPressed: context.profileTilesCubit.onSettingsTilePressed,
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

class SyncDataTile extends StatelessWidget {
  const SyncDataTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgSync,
      label: l.syncData,
      onPressed: context.syncUserAudioCubit.onSyncDataPressed,
    );
  }
}

class SyncSpotifyPlaylistsFiles extends StatelessWidget {
  const SyncSpotifyPlaylistsFiles({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return _ProfileTile(
      iconAssetName: Assets.svgSync,
      label: l.syncSpotifyPlaylists,
      onPressed: context.importSpotifyPlaylistsCubit.onImportSpotifyPlaylists,
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
  });

  final String iconAssetName;
  final String label;
  final VoidCallback onPressed;

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
            Text(label),
          ],
        ),
      ),
    );
  }
}
