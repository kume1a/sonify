import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/failure_intl.dart';
import '../../../shared/ui/loading_text_button.dart';
import '../../../shared/ui/logo_header.dart';
import '../state/email_sign_in_state.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return TapOutsideToClearFocus(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 12),
              child: BlocBuilder<EmailSignInCubit, EmailSignInState>(
                buildWhen: (previous, current) => previous.validateForm != current.validateForm,
                builder: (_, state) {
                  return ValidatedForm(
                    showErrors: state.validateForm,
                    child: const Column(
                      children: [
                        Spacer(flex: 2),
                        LogoHeaderMedium(),
                        Spacer(),
                        _FieldEmail(),
                        SizedBox(height: 16),
                        _FieldPassword(),
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: _ButtonSignIn(),
                        ),
                        SizedBox(height: 12),
                        _EmailSignInErrortext(),
                        Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldEmail extends StatelessWidget {
  const _FieldEmail();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: l.email,
      ),
      onChanged: context.emailSignInCubit.onEmailChanged,
      validator: (_) => context.emailSignInCubit.state.email.failureToString((f) => f.translate(l)),
    );
  }
}

class _FieldPassword extends StatelessWidget {
  const _FieldPassword();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: l.password,
      ),
      onChanged: context.emailSignInCubit.onPasswordChanged,
      validator: (_) => context.emailSignInCubit.state.password.failureToString((f) => f.translate(l)),
    );
  }
}

class _ButtonSignIn extends StatelessWidget {
  const _ButtonSignIn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailSignInCubit, EmailSignInState>(
      buildWhen: (previous, current) => previous.signInState != current.signInState,
      builder: (_, state) {
        final l = AppLocalizations.of(context);

        return LoadingTextButton(
          onPressed: context.emailSignInCubit.onSignInPressed,
          label: l.signIn,
          isLoading: state.signInState.isExecuting,
        );
      },
    );
  }
}

class _EmailSignInErrortext extends StatelessWidget {
  const _EmailSignInErrortext();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<EmailSignInCubit, EmailSignInState>(
      buildWhen: (previous, current) => previous.signInState != current.signInState,
      builder: (context, state) {
        if (!state.signInState.isFailed) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            state.signInState.failureOrNull?.translate(l) ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      },
    );
  }
}
