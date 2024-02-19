import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';
import '../state/auth_state.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.white,
      onPressed: context.authCubit.onGoogleSignIn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.svgGoogle,
            width: 20,
            height: 20,
          ),
          const Expanded(
            child: Text(
              'Sign in with Google',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
