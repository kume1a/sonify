import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/auth/state/sign_out_state.dart';
import '../features/auth/ui/sign_out_button.dart';
import '../features/spotifyauth/state/auth_spotify_state.dart';
import '../features/spotifyauth/ui/auth_spotify_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SignOutCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthSpotifyCubit>(),
        ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AuthSpotifyButton(),
          SignOutButton(),
        ],
      ),
    );
  }
}
