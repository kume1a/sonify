import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/download_file/model/downloads_event.dart';
import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../../../shared/ui/toast_notifier.dart';
import '../../../shared/values/assets.dart';
import '../model/event_playlist_audio.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistCachedRepository,
    this._bottomSheetManager,
    this._eventBus,
    this._toastNotifier,
  );

  final PlaylistCachedRepository _playlistCachedRepository;
  final BottomSheetManager _bottomSheetManager;
  final EventBus _eventBus;
  final ToastNotifier _toastNotifier;

  String? _playlistId;

  final _subscriptions = SubscriptionComposite();

  void init(String playlistId) {
    _playlistId = playlistId;

    _subscriptions.add(_eventBus.on<EventPlaylistAudio>().listen(_onPlaylistAudioEvent));

    loadEntityAndEmit();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  @override
  Future<Playlist?> loadEntity() async {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.loadEntity: _playlistId is null');
      return null;
    }

    final res = await _playlistCachedRepository.getById(_playlistId!);

    return res.dataOrNull;
  }

  Future<void> onPlaylistAudioMenuPressed(PlaylistAudio playlistAudio) async {
    final isDownloaded = playlistAudio.audio?.localPath != null;

    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (l) => playlistAudio.audio?.title ?? l.audio,
      options: [
        SelectOption(
          value: 0,
          label: (l) => isDownloaded ? l.alreadyDownloaded : l.download,
          iconAssetName: Assets.svgDownload,
          isActive: !isDownloaded,
        ),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        if (playlistAudio.audio == null || playlistAudio.audio?.localPath != null) {
          Logger.root
              .warning('PlaylistCubit.onPlaylistAudioMenuPressed: audio is null or already downloaded');
          return;
        }

        _eventBus.fire(DownloadsEvent.enqueuePlaylistAudio(playlistAudio));

        _toastNotifier.info(description: (l) => l.downloadStarted);
        break;
    }
  }

  void _onPlaylistAudioEvent(EventPlaylistAudio event) {
    event.when(
      downloaded: (playlistAudio) async {
        final newState = await state.map((playlist) {
          final containsPlaylistAudio =
              playlist.playlistAudios?.any((e) => e.id == playlistAudio.id) ?? false;

          if (!containsPlaylistAudio) {
            return playlist;
          }

          return playlist.copyWith(
            playlistAudios:
                playlist.playlistAudios?.replace((e) => e.id == playlistAudio.id, (_) => playlistAudio),
          );
        });

        emit(newState);
      },
    );
  }

  void onDownloadPlaylistPressed() {
    final playlist = state.getOrNull;

    if (playlist == null) {
      Logger.root.warning('PlaylistCubit.onDownloadPlaylistPressed: playlist is null');
      return;
    }

    final playlistAudios = playlist.playlistAudios;

    if (playlistAudios == null || playlistAudios.isEmpty) {
      Logger.root.warning('PlaylistCubit.onDownloadPlaylistPressed: playlistAudios is null or empty');
      return;
    }

    final playlistAudiosToDownload = playlistAudios.where((e) => e.audio?.localPath == null).toList();

    if (playlistAudiosToDownload.isEmpty) {
      _toastNotifier.info(description: (l) => l.allAudiosAlreadyDownloaded);
      return;
    }

    for (final playlistAudio in playlistAudiosToDownload) {
      if (playlistAudio.audio == null) {
        Logger.root.warning('PlaylistCubit.onDownloadPlaylistPressed: audio is null');
        continue;
      }

      _eventBus.fire(DownloadsEvent.enqueuePlaylistAudio(playlistAudio));
    }

    _toastNotifier.info(
      description: (l) => l.startedDownloadingNAudios(playlistAudiosToDownload.length),
    );
  }
}
