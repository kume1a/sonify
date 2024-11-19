import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/user_preferences_state.dart';

class SaveShuffleStatePreferenceTile extends StatelessWidget {
  const SaveShuffleStatePreferenceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (previous, current) =>
          previous.isSaveShuffleStateEnabled != current.isSaveShuffleStateEnabled,
      builder: (_, state) {
        return state.isSaveShuffleStateEnabled.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (value) => _BoolPreferenceTile(
            label: l.saveShuffleState,
            value: value,
            onChanged: context.userPreferencesCubit.onToggleSaveShuffleState,
          ),
        );
      },
    );
  }
}

class SaveRepeatStatePreferenceTile extends StatelessWidget {
  const SaveRepeatStatePreferenceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (previous, current) => previous.isSaveRepeatStateEnabled != current.isSaveRepeatStateEnabled,
      builder: (_, state) {
        return state.isSaveRepeatStateEnabled.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (value) => _BoolPreferenceTile(
            label: l.saveRepeatState,
            value: value,
            onChanged: context.userPreferencesCubit.onToggleSaveRepeatState,
          ),
        );
      },
    );
  }
}

class EnableSearchHistoryPreferenceTile extends StatelessWidget {
  const EnableSearchHistoryPreferenceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (previous, current) => previous.isSearchHistoryEnabled != current.isSearchHistoryEnabled,
      builder: (_, state) {
        return state.isSearchHistoryEnabled.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (value) => _BoolPreferenceTile(
            label: l.enableSearchHistory,
            value: value,
            onChanged: context.userPreferencesCubit.onToggleSearchHistory,
          ),
        );
      },
    );
  }
}

class _BoolPreferenceTile extends StatelessWidget {
  const _BoolPreferenceTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
