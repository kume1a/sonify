import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/loading_text_button.dart';
import '../state/sign_out_state.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<SignOutCubit, SignOutState>(
      buildWhen: (previous, current) => previous.signOutState != current.signOutState,
      builder: (_, state) {
        return LoadingTextButton(
          onPressed: context.signOutCubit.onSignOutPressed,
          label: l.signOut,
          isLoading: state.signOutState.isExecuting,
        );
      },
    );
  }
}
