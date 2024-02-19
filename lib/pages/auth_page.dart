import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/auth/state/auth_state.dart';

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
      builder: (context, state) {
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
    return const Scaffold(
      body: SafeArea(
        child: SizedBox.shrink(),
      ),
    );
  }
}
