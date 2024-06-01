import 'dart:async';

import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../pages/playlist_page.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../model/event_spotify_playlists_imported.dart';

typedef SpotifyPlaylistListState = SimpleDataState<List<Playlist>>;

extension SpotifyPlaylistListCubitX on BuildContext {
  SpotifyPlaylistListCubit get spotifyPlaylistListCubit => read<SpotifyPlaylistListCubit>();
}

@injectable
final class SpotifyPlaylistListCubit extends EntityLoaderCubit<List<Playlist>> {
  SpotifyPlaylistListCubit(
    this._playlistRemoteRepository,
    this._pageNavigator,
    this._eventBus,
  ) {
    init();
    loadEntityAndEmit();
  }

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PageNavigator _pageNavigator;
  final EventBus _eventBus;

  Timer? _pollingTimer;
  final _subscriptions = SubscriptionComposite();

  void init() {
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
        final playlists = state.getOrNull;
        if (playlists == null) {
          loadEntityAndEmit(emitLoading: false);
          return;
        }

        final allPlaylistsImported =
            playlists.every((playlist) => playlist.audioImportStatus == ProcessStatus.completed);

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
  Future<List<Playlist>?> loadEntity() async {
    final res = await _playlistRemoteRepository.getAuthUserPlaylists();

    return res.rightOrNull;
  }

  void onPlaylistPressed(Playlist playlist) {
    final args = PlaylistPageArgs(playlistId: playlist.id);

    _pageNavigator.toPlaylist(args);
  }

  void onViewAllPressed() {}
}
