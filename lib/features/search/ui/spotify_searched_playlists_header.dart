import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/assets.dart';
import '../state/spotify_search_state.dart';

class SpotifySearchedPlaylistsHeader extends StatelessWidget {
  const SpotifySearchedPlaylistsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifySearchCubit, SpotifySearchState>(
      builder: (_, state) => state.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        success: (data) => data.playlists.isEmpty ? const SizedBox.shrink() : const _Header(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          SvgPicture.asset(Assets.svgSpotify, width: 24, height: 24),
          const SizedBox(width: 6),
          Text(
            l.spotifyPlaylists,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
