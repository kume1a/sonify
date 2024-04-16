import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/intl/app_localizations.dart';
import '../../../shared/ui/list_header.dart';
import '../../../shared/util/equality.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../state/import_local_music_state.dart';

class UploadLocalMusicProgress extends StatelessWidget {
  const UploadLocalMusicProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return BlocBuilder<ImportLocalMusicCubit, ImportLocalMusicState>(
      buildWhen: (previous, current) =>
          notDeepEquals(previous.uploadedLocalMusicResults, current.uploadedLocalMusicResults) ||
          previous.stage != current.stage ||
          previous.uploadProgress != current.uploadProgress,
      builder: (_, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.uploadingLocalMusic != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 4),
                  child: Text(
                    l.uploadingMusic(state.uploadingLocalMusic!.title),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                l.uploadedProgress((state.uploadProgress * 100).round()),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: theme.appThemeExtension?.elSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: state.uploadProgress,
                ),
              ),
              if (state.stage == ImportLocalMusicStage.finished)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: TextButton(
                    onPressed: context.importLocalMusicCubit.onGoBackPressed,
                    child: Text(l.goBack),
                  ),
                ),
              if (state.uploadedLocalMusicResults.isNotEmpty) ...[
                const SizedBox(height: 24),
                ListHeader(text: l.uploaded),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.uploadedLocalMusicResults.length,
                    itemBuilder: (_, index) {
                      final uploadedResult = state.uploadedLocalMusicResults[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                uploadedResult.localMusic.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (uploadedResult.failure != null)
                              Text(
                                uploadedResult.failure!.when(
                                  unknown: () => l.unknownError,
                                  network: () => l.noInternet,
                                  alreadyUploaded: () => l.alreadyUploaded,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.error,
                                ),
                              )
                            else
                              Icon(
                                Icons.check,
                                color: theme.appThemeExtension?.success,
                                size: 18,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
