import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/register_dependencies.dart';
import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/error_intl.dart';
import '../state/mutate_playlist_state.dart';

class MutatePlaylistDialog extends StatelessWidget {
  const MutatePlaylistDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutatePlaylistCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Dialog(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<MutatePlaylistCubit, MutatePlaylistState>(
            buildWhen: (previous, current) => previous.validateForm != current.validateForm,
            builder: (_, state) {
              return ValidatedForm(
                showErrors: state.validateForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.createPlaylist),
                    const SizedBox(height: 16),
                    TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: l.name,
                      ),
                      onChanged: context.mutatePlaylistCubit.onNameChanged,
                      validator: (_) => context.mutatePlaylistCubit.state.name.errToString(
                        (err) => err.translate(l),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: context.mutatePlaylistCubit.onSubmit,
                      child: Text(l.submit),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
