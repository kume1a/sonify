import 'dart:async';

import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/playlist_page.dart';
import '../model/event_spotify_playlists_imported.dart';

typedef PlaylistListState = SimpleDataState<List<UserPlaylist>>;

extension PlaylistListCubitX on BuildContext {
  PlaylistListCubit get spotifyPlaylistListCubit => read<PlaylistListCubit>();
}

@injectable
final class PlaylistListCubit extends Cubit<PlaylistListState> {
  PlaylistListCubit(
    this._userPlaylistRemoteRepository,
    this._userPlaylistLocalRepository,
    this._pageNavigator,
    this._eventBus,
    this._authUserInfoProvider,
  ) : super(PlaylistListState.idle()) {
    init();
  }

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final PageNavigator _pageNavigator;
  final EventBus _eventBus;
  final AuthUserInfoProvider _authUserInfoProvider;

  Timer? _pollingTimer;
  final _subscriptions = SubscriptionComposite();

  Future<void> init() async {
    _subscriptions.add(
      _eventBus.on<EventSpotifyPlaylistsImported>().listen((_) => _startPollingTimer()),
    );

    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      Logger.root.warning('User is not authenticated, cannot load playlists');
      return;
    }

    emit(PlaylistListState.loading());

    final remotePlaylistsRes = await _userPlaylistRemoteRepository.getAllFullByAuthUser();

    Logger.root.info('Remote playlists: $remotePlaylistsRes');

    if (remotePlaylistsRes.isRight) {
      final remotePlaylists = remotePlaylistsRes.rightOrThrow;

      emit(SimpleDataState.success(remotePlaylists));

      if (!isAllPlaylistsImported(remotePlaylists)) {
        _startPollingTimer();
      }

      return;
    }

    final localPlaylists = await _userPlaylistLocalRepository.getAllByUserId(userId);

    Logger.root.info('Local playlists: $localPlaylists');

    localPlaylists.fold(
      () => emit(SimpleDataState.failure()),
      (r) {
        if (isAllPlaylistsImported(r)) {
          emit(SimpleDataState.success(r));
          return;
        }

        Logger.root.warning('Local playlists are not imported, emitting failure');
        emit(SimpleDataState.failure());
      },
    );
  }

  void _startPollingTimer() {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        final userPlaylists = state.getOrNull;

        if (userPlaylists != null && isAllPlaylistsImported(userPlaylists)) {
          _pollingTimer?.cancel();
          return;
        }

        loadRemotePlaylistsAndEmit(emitLoading: false);
      },
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _subscriptions.closeAll();

    return super.close();
  }

  Future<void> loadRemotePlaylistsAndEmit({
    bool emitLoading = true,
  }) async {
    if (emitLoading) {
      emit(PlaylistListState.loading());
    }

    final res = await _userPlaylistRemoteRepository.getAllFullByAuthUser();

    emit(SimpleDataState.fromEither(res));
  }

  void onPlaylistPressed(UserPlaylist userPlaylist) {
    final args = PlaylistPageArgs(playlistId: userPlaylist.playlistId);

    _pageNavigator.toPlaylist(args);
  }

  bool isAllPlaylistsImported(List<UserPlaylist> userPlaylists) {
    return userPlaylists.every((userPlaylist) =>
        userPlaylist.playlist != null && userPlaylist.playlist?.audioImportStatus == ProcessStatus.completed);
  }
}
