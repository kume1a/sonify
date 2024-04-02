import 'package:flutter/material.dart';

import '../state/auth_spotify_state.dart';

class AuthSpotifyButton extends StatelessWidget {
  const AuthSpotifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: context.authSpotifyCubit.onAuthorizePressed,
      child: const Text('Authorize Spotify'),
    );
  }
}
