import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/failure_intl.dart';
import '../state/update_user_name_state.dart';

class UpdateUserNameForm extends StatelessWidget {
  const UpdateUserNameForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<UpdateUserNameCubit, UpdateUserNameState>(
      buildWhen: (previous, current) =>
          previous.validateForm != current.validateForm || previous.submitState != current.submitState,
      builder: (_, state) {
        return ValidatedForm(
          showErrors: state.validateForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: l.enterYourName),
                onChanged: context.updateUserNameCubit.onNameChanged,
                validator: (value) => context.updateUserNameCubit.state.name.failureToString(
                  (f) => f.translate(l),
                ),
              ),
              const SizedBox(height: 16),
              if (state.submitState.isFailed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    state.submitState.failureOrNull?.translate(l) ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              Button(
                showCircularProgressIndicator: state.submitState.isExecuting,
                onPressed: context.updateUserNameCubit.onSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
