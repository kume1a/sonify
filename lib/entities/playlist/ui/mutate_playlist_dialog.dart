import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/register_dependencies.dart';
import '../../../app/intl/app_localizations.dart';
import '../../../app/intl/extension/error_intl.dart';
import '../state/mutate_playlist_state.dart';

class MutatePlaylistDialog extends StatelessWidget {
  const MutatePlaylistDialog({
    super.key,
    required this.userPlaylistId,
  });

  final String? userPlaylistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutatePlaylistCubit>()..init(userPlaylistId: userPlaylistId),
      child: _Content(
        userPlaylistId: userPlaylistId,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.userPlaylistId,
  });

  final String? userPlaylistId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Dialog(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<MutatePlaylistCubit, MutatePlaylistState>(
            buildWhen: (previous, current) => previous.validateForm != current.validateForm,
            builder: (_, state) {
              return ValidatedForm(
                showErrors: state.validateForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(userPlaylistId != null ? l.editPlaylistDetails : l.createPlaylist),
                    const SizedBox(height: 16),
                    TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: l.name,
                        fillColor: theme.colorScheme.secondaryContainer,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      onChanged: context.mutatePlaylistCubit.onNameChanged,
                      validator: (_) => context.mutatePlaylistCubit.state.name.errToString(
                        (err) => err.translate(l),
                      ),
                    ),
                    const SizedBox(height: 12),
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
