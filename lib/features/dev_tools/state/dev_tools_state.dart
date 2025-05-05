import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/dialog/dialog_manager.dart';
import '../../../shared/ui/toast_notifier.dart';

extension DevToolsCubitX on BuildContext {
  DevToolsCubit get userPreferencesCubit => read<DevToolsCubit>();
}

@injectable
class DevToolsCubit extends Cubit<Unit> {
  DevToolsCubit(
    this._authUserInfoProvider,
    this._userAudioLocalRepository,
    this._playlistAudioLocalRepository,
    this._toastNotifier,
    this._dialogManager,
  ) : super(unit);

  final AuthUserInfoProvider _authUserInfoProvider;
  final UserAudioLocalRepository _userAudioLocalRepository;
  final PlaylistAudioLocalRepository _playlistAudioLocalRepository;
  final ToastNotifier _toastNotifier;
  final DialogManager _dialogManager;

  Future<void> onDeleteAllDownloadedUserAudios() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      Logger.root.info('User ID is null, cannot delete downloaded audios.');
      return;
    }

    final userAudioCount = await _userAudioLocalRepository.getCountByUserId(userId);
    if (userAudioCount.isErr) {
      Logger.root.info('Failed to get user audio count');
      return;
    }

    if (userAudioCount.dataOrThrow == 0) {
      _dialogManager.showStatusDialog(content: (l) => l.noDownloadedUserAudiosToDelete);
      return;
    }

    final didConfirm = await _dialogManager.showConfirmationDialog(
      title: (l) => l.confirmToDelete,
      caption: (l) => l.deleteAllDownloadedUserAudiosConfirmation(userAudioCount.dataOrThrow),
    );

    if (!didConfirm) {
      return;
    }

    final deleteRes = await _userAudioLocalRepository.deleteAllByUserId(userId);

    deleteRes.fold(
      () => _toastNotifier.error(
        title: (l) => l.error,
        description: (l) => l.failedToDeleteAllDownloadedUserAudios,
      ),
      () => _toastNotifier.success(
        title: (l) => l.success,
        description: (l) => l.successfullyDeletedAllDownloadedUserAudios,
      ),
    );
  }

  Future<void> onDeleteAllDownloadedPlaylistAudioFilesPressed() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      Logger.root.info('User ID is null, cannot delete downloaded audios.');
      return;
    }

    final playlistAudioCount = await _playlistAudioLocalRepository.countOnlyLocalPathPresentByUserId(userId);
    if (playlistAudioCount.isErr) {
      Logger.root.info('Failed to get playlist audio count');
      return;
    }

    if (playlistAudioCount.dataOrThrow == 0) {
      _dialogManager.showStatusDialog(content: (l) => l.noDownloadedPlaylistAudioFilesToDelete);
      return;
    }

    final didConfirm = await _dialogManager.showConfirmationDialog(
      title: (l) => l.confirmToDelete,
      caption: (l) => l.deleteAllDownloadedPlaylistAudioFilesConfirmation(playlistAudioCount.dataOrThrow),
    );

    if (!didConfirm) {
      return;
    }

    final deleteRes = await _playlistAudioLocalRepository.deleteAllDownloadedAudioLocalFilesByUserId(userId);

    deleteRes.fold(
      () => _toastNotifier.error(
        title: (l) => l.error,
        description: (l) => l.failedToDeleteAllDownloadedPlaylistAudioFiles,
      ),
      () => _toastNotifier.success(
        title: (l) => l.success,
        description: (l) => l.successfullyDeletedAllDownloadedPlaylistAudioFiles,
      ),
    );
  }
}
