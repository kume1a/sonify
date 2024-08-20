import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/intl/extension/error_intl.dart';
import '../../../app/navigation/page_navigator.dart';
import '../../../features/download_file/model/downloads_event.dart';
import '../../../features/spotifyauth/api/spotify_access_token_provider.dart';
import '../../../pages/search_playlist_audios_page.dart';
import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../../../shared/ui/toast_notifier.dart';
import '../../../shared/values/assets.dart';
import '../model/event_playlist_audio.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistStateX on PlaylistState {
  bool get isPlaylistPlayable {
    return maybeWhen(
      success: (data) =>
          data.audioImportStatus == ProcessStatus.completed && data.audioCount == data.totalAudioCount,
      orElse: () => false,
    );
  }
}

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistCachedRepository,
    this._userAudioLocalRepository,
    this._userAudioRemoteRepository,
    this._bottomSheetManager,
    this._eventBus,
    this._toastNotifier,
    this._authUserInfoProvider,
    this._pageNavigator,
    this._playlistUpdatedEventChannel,
    this._spotifyRemoteRepository,
    this._spotifyAccessTokenProvider,
  );

  final UserAudioLocalRepository _userAudioLocalRepository;
  final PlaylistCachedRepository _playlistCachedRepository;
  final UserAudioRemoteRepository _userAudioRemoteRepository;
  final BottomSheetManager _bottomSheetManager;
  final EventBus _eventBus;
  final ToastNotifier _toastNotifier;
  final AuthUserInfoProvider _authUserInfoProvider;
  final PageNavigator _pageNavigator;
  final PlaylistUpdatedEventChannel _playlistUpdatedEventChannel;
  final SpotifyRemoteRepository _spotifyRemoteRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;

  String? _playlistId;

  final _subscriptions = SubscriptionComposite();

  void init(String playlistId) {
    _playlistId = playlistId;

    _subscriptions.addAll([
      _eventBus.on<EventPlaylistAudio>().listen(_onPlaylistAudioEvent),
      _playlistUpdatedEventChannel.events.listen(_onPlaylistChanged),
    ]);

    _playlistUpdatedEventChannel.startListening();

    loadEntityAndEmit();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();
    await _playlistUpdatedEventChannel.dispose();

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

  void onSearchContainerPressed() {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.onSearchContainerPressed: _playlistId is null');
      return;
    }

    final args = SearchPlaylistAudiosPageArgs(playlistId: _playlistId!);

    _pageNavigator.toSearchPlaylistAudios(args);
  }

  Future<void> onPlaylistMenuPressed() async {
    final playlist = state.getOrNull;

    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (l) => playlist?.name ?? l.playlist,
      options: [
        SelectOption(
          value: 0,
          label: (l) => l.downloadPlaylist,
          iconAssetName: Assets.svgDownload,
        ),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        _triggerDownloadPlaylist();
        break;
    }
  }

  Future<void> onPlaylistAudioMenuPressed(PlaylistAudio playlistAudio) async {
    if (playlistAudio.audio?.id == null) {
      Logger.root.warning('PlaylistCubit.onPlaylistAudioMenuPressed: audio id is null');
      return;
    }

    final authUserId = await _authUserInfoProvider.getId();
    if (authUserId == null) {
      Logger.root.warning('PlaylistCubit.onPlaylistAudioMenuPressed: authUserId is null');
      return;
    }

    final isDownloaded = playlistAudio.audio?.localPath != null;

    final localUserAudioRes = await _userAudioLocalRepository.getByUserIdAndAudioId(
      userId: authUserId,
      audioId: playlistAudio.audio!.id!,
    );
    final userAudioExists = localUserAudioRes.dataOrNull != null;

    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (l) => playlistAudio.audio?.title ?? l.audio,
      options: [
        SelectOption(
          value: 0,
          label: (l) => isDownloaded ? l.alreadyDownloaded : l.download,
          iconAssetName: Assets.svgDownload,
          isActive: !isDownloaded,
        ),
        if (isDownloaded)
          SelectOption(
            value: 1,
            label: (l) => userAudioExists ? l.alreadyAddedToMyLibrary : l.addToMyLibrary,
            iconAssetName: Assets.svgPlus,
            isActive: !userAudioExists,
          ),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        return _triggerDownloadPlaylistAudio(playlistAudio);
      case 1:
        return _triggerAddAudioToMyLibrary(playlistAudio);
    }
  }

  Future<void> _triggerDownloadPlaylistAudio(PlaylistAudio playlistAudio) async {
    if (playlistAudio.audio?.localPath != null) {
      Logger.root.warning('PlaylistCubit.onPlaylistAudioMenuPressed: audio already downloaded');
      return;
    }

    _eventBus.fire(DownloadsEvent.enqueuePlaylistAudio(playlistAudio));

    _toastNotifier.info(description: (l) => l.downloadStarted);
  }

  Future<void> _triggerAddAudioToMyLibrary(PlaylistAudio playlistAudio) {
    return _userAudioRemoteRepository.createManyForAuthUser(
      audioIds: [playlistAudio.audio!.id!],
    ).awaitFold(
      (err) => _toastNotifier.error(description: (l) => err.translate(l)),
      (r) async {
        if (r.isEmpty) {
          Logger.root
              .warning('PlaylistCubit.onPlaylistAudioMenuPressed: user audios created but result is empty');
          return;
        }

        final localUserAudio = await _userAudioLocalRepository.save(r.first);
        if (localUserAudio.isErr) {
          _toastNotifier.error(description: (l) => l.failedToAddToMyLibrary);
          return;
        }

        _toastNotifier.info(description: (l) => l.addedToMyLibrary);
      },
    );
  }

  void _triggerDownloadPlaylist() {
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

  void _onPlaylistAudioEvent(EventPlaylistAudio event) {
    event.when(
      downloaded: (playlistAudio) async {
        final newState = await state.map((playlist) {
          return playlist.copyWith(
            playlistAudios: playlist.playlistAudios?.replace(
              (e) => e.id == playlistAudio.id,
              (_) => playlistAudio,
            ),
          );
        });

        emit(newState);
      },
    );
  }

  Future<void> _onPlaylistChanged(Playlist newPlaylist) async {
    if (newPlaylist.audioImportStatus != ProcessStatus.completed) {
      emit(SimpleDataState.success(newPlaylist));
      return;
    }

    loadEntityAndEmit();
  }

  Future<void> onRetryImportPlaylist() async {
    final playlist = state.getOrNull;
    if (playlist == null || playlist.spotifyId == null) {
      Logger.root.warning('PlaylistCubit.onRetryImportPlaylist: playlist or spotifyId is null');
      return;
    }

    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      Logger.root.warning('SpotifySearchCubit.onSearchedPlaylistPressed: Spotify access token is null');
      return;
    }

    final res = await _spotifyRemoteRepository.importSpotifyPlaylist(
      spotifyPlaylistId: playlist.spotifyId!,
      spotifyAccessToken: spotifyAccessToken,
    );

    return res.fold(
      (error) => _toastNotifier.error(
        description: (l) => l.failedToImportSpotifyPlaylist,
      ),
      (r) {
        _playlistId = r.id;

        _toastNotifier.success(
          description: (l) => l.importingSpotifyPlaylist,
        );

        emit(SimpleDataState.success(r));
      },
    );
  }
}
