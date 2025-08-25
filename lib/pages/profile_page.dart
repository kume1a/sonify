import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/playlist/state/import_spotify_playlists_state.dart';
import '../entities/user/state/auth_user_state.dart';
import '../entities/user/state/profile_tiles_state.dart';
import '../entities/user/ui/auth_user_profile_header.dart';
import '../entities/user/ui/profile_tiles.dart';
import '../features/auth/state/sign_out_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SignOutCubit>()),
        BlocProvider(create: (_) => getIt<AuthUserCubit>()),
        BlocProvider(create: (_) => getIt<ProfileTilesCubit>()),
        BlocProvider(create: (_) => getIt<ImportSpotifyPlaylistsCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          AuthUserProfileHeader(),
          SizedBox(height: 16),
          DownloadsTile(),
          PreferencesTile(),
          Divider(
            indent: 16,
            endIndent: 16,
          ),
          ImportLocalAudioFilesTile(),
          ImporSpotifyPlaylistsTile(),
          ChangeServerUrlOriginTile(),
          FlappyPlaneTile(),
          if (kDebugMode) DevToolsTile(),
          SignOutTile(),
        ],
      ),
    );
  }
}
