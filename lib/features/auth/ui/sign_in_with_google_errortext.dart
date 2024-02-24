import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/auth_state.dart';

class SignInWithGoogleErrortext extends StatelessWidget {
  const SignInWithGoogleErrortext({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.googleSignInAction != current.googleSignInAction,
      builder: (context, state) {
        if (!state.googleSignInAction.isFailed) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            l.signInWithGoogleError,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      },
    );
  }
}
