import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/auth/state/email_sign_in_state.dart';
import '../features/auth/ui/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmailSignInCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: EmailSignInForm(),
      ),
    );
  }
}
