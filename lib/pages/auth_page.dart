import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/auth/state/auth_state.dart';
import '../features/auth/ui/sign_in_with_email_button.dart';
import '../features/auth/ui/sign_in_with_google_button.dart';
import '../features/auth/ui/sign_in_with_google_errortext.dart';
import '../shared/ui/logo_header.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
      ],
      child: const _ShowOnOnlyAuth(
        child: _Content(),
      ),
    );
  }
}

class _ShowOnOnlyAuth extends StatelessWidget {
  const _ShowOnOnlyAuth({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.isAuthenticated != current.isAuthenticated,
      builder: (_, state) {
        return state.isAuthenticated.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (isAuthenticated) {
            if (isAuthenticated) {
              return const SizedBox.shrink();
            }

            return child;
          },
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoHeaderMedium(),
              SizedBox(height: 28),
              SignInWithGoogleButton(),
              SignInWithGoogleErrortext(),
              SignInWithEmailButton(),
            ],
          ),
        ),
      ),
    );
  }
}
