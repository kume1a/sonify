import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../features/update_user/state/update_user_name_state.dart';
import '../features/update_user/ui/update_user_name_form.dart';
import '../shared/ui/logo_header.dart';

class UserNamePage extends StatelessWidget {
  const UserNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UpdateUserNameCubit>(),
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
        child: Column(
          children: [
            LogoHeaderMedium(),
            SizedBox(height: 24),
            UpdateUserNameForm(),
          ],
        ),
      ),
    );
  }
}
