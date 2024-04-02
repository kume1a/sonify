import 'package:flutter/material.dart';

import '../state/spotify_auth_state.dart';

class AuthSpotifyButton extends StatelessWidget {
  const AuthSpotifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: context.authSpotifyCubit.onAuthorizePressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 16, 105, 47),
        backgroundColor: const Color(0xFF1DB954),
      ),
      child: const Text(
        'Authorize Spotify',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
