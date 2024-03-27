import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';
import '../state/auth_state.dart';

class SignInWithEmailButton extends StatelessWidget {
  const SignInWithEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.white,
      onPressed: context.authCubit.onEmailSignIn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.svgMail,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 6),
          const Text(
            'Continue with email',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
