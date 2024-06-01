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
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../model/event_spotify_playlists_imported.dart';

typedef PlaylistListState = SimpleDataState<List<UserPlaylist>>;

extension PlaylistListCubitX on BuildContext {
  PlaylistListCubit get spotifyPlaylistListCubit => read<PlaylistListCubit>();
}

@injectable
final class PlaylistListCubit extends EntityLoaderCubit<List<UserPlaylist>> {
  PlaylistListCubit(
    this._userPlaylistRemoteRepository,
    this._userPlaylistLocalRepository,
    this._pageNavigator,
    this._eventBus,
    this._authUserInfoProvider,
  ) {
    init();
    loadEntityAndEmit();
  }

  final UserPlaylistRemoteRepository _userPlaylistRemoteRepository;
  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final PageNavigator _pageNavigator;
  final EventBus _eventBus;
  final AuthUserInfoProvider _authUserInfoProvider;

  Timer? _pollingTimer;
  final _subscriptions = SubscriptionComposite();

  Future<void> init() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      return;
    }

    final localPlaylists = await _userPlaylistLocalRepository.getAllByUserId(userId);
    Logger.root.info('Local playlists: $localPlaylists');

    _subscriptions.add(
      _eventBus.on<EventSpotifyPlaylistsImported>().listen((_) => _startPollingTimer()),
    );

    _startPollingTimer();
  }

  void _startPollingTimer() {
    if (_pollingTimer != null) {
      return;
    }

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        final userPlaylists = state.getOrNull;
        if (userPlaylists == null) {
          loadEntityAndEmit(emitLoading: false);
          return;
        }

        final allPlaylistsImported = userPlaylists.every((userPlaylist) =>
            userPlaylist.playlist != null &&
            userPlaylist.playlist?.audioImportStatus == ProcessStatus.completed);

        if (!allPlaylistsImported) {
          loadEntityAndEmit(emitLoading: false);
        } else {
          _pollingTimer?.cancel();
        }
      },
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();

    return super.close();
  }

  @override
  Future<List<UserPlaylist>?> loadEntity() async {
    final res = await _userPlaylistRemoteRepository.getAllFullByAuthUser();

    return res.rightOrNull;
  }

  void onPlaylistPressed(UserPlaylist userPlaylist) {
    final args = PlaylistPageArgs(playlistId: userPlaylist.playlistId);

    _pageNavigator.toPlaylist(args);
  }

  void onViewAllPressed() {}
}
