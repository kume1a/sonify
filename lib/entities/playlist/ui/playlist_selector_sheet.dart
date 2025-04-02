import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/register_dependencies.dart';
import '../../../app/intl/app_localizations.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/playlist_selector_state.dart';

class PlaylistSelectorSheet extends StatelessWidget {
  const PlaylistSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlaylistSelectorCubit>(),
      child: _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Material(
      color: theme.appThemeExtension?.bgPopup,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * .6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  l.playlists,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.appThemeExtension?.elSecondary,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              Flexible(
                child: BlocBuilder<PlaylistSelectorCubit, SimpleDataState<List<UserPlaylist>>>(
                  builder: (_, state) {
                    return state.maybeWhen(
                      orElse: () => SizedBox.shrink(),
                      success: (data) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (_, int index) {
                          final userPlaylist = data[index];

                          return InkWell(
                            onTap: () => Navigator.of(context).maybePop(userPlaylist.playlist),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(
                                userPlaylist.playlist?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
