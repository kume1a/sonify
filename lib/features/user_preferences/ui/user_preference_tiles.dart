import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../state/user_preferences_state.dart';

class SaveShuffleStatePrefTile extends StatelessWidget {
  const SaveShuffleStatePrefTile({super.key});

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

class SaveRepeatStatePrefTile extends StatelessWidget {
  const SaveRepeatStatePrefTile({super.key});

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

class EnableSearchHistoryPrefTile extends StatelessWidget {
  const EnableSearchHistoryPrefTile({super.key});

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

class MaxConcurrentDownloadCountPrefTile extends StatelessWidget {
  const MaxConcurrentDownloadCountPrefTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (previous, current) =>
          previous.maxConcurrentDownloadCount != current.maxConcurrentDownloadCount,
      builder: (_, state) {
        return state.maxConcurrentDownloadCount.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (value) => ListTile(
            title: Text(l.maxConcurrentDownloadCount),
            trailing: DropdownButton<int>(
              dropdownColor: theme.colorScheme.primaryContainer,
              value: value,
              items: List.generate(10, (index) => index + 1).map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text(count.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  context.userPreferencesCubit.onChangeMaxConcurrentDownloadCount(newValue);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _BoolPreferenceTile extends StatelessWidget {
  const _BoolPreferenceTile({
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
