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

typedef PlaylistListState = SimpleDataState<List<UserPlaylist>>;

extension PlaylistListCubitX on BuildContext {
  PlaylistListCubit get playlistListCubit => read<PlaylistListCubit>();
}

@injectable
final class PlaylistListCubit extends Cubit<PlaylistListState> {
  PlaylistListCubit(
    this._userPlaylistLocalRepository,
    this._pageNavigator,
    this._authUserInfoProvider,
    this._playlistUpdatedEventChannel,
  ) : super(PlaylistListState.idle()) {
    init();
  }

  final UserPlaylistLocalRepository _userPlaylistLocalRepository;
  final PageNavigator _pageNavigator;
  final AuthUserInfoProvider _authUserInfoProvider;
  final PlaylistUpdatedEventChannel _playlistUpdatedEventChannel;

  final _subscriptions = SubscriptionComposite();

  Future<void> init() async {
    _subscriptions.add(_playlistUpdatedEventChannel.events.listen(_onPlaylistChanged));

    _playlistUpdatedEventChannel.startListening();

    _loadPlaylists();
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();
    await _playlistUpdatedEventChannel.dispose();

    return super.close();
  }

  Future<void> onRefresh() {
    return _loadPlaylists();
  }

  void onPlaylistPressed(UserPlaylist userPlaylist) {
    final args = PlaylistPageArgs(playlistId: userPlaylist.playlistId);

    _pageNavigator.toPlaylist(args);
  }

  bool _isAllPlaylistsImported(List<UserPlaylist> userPlaylists) {
    return userPlaylists.every((userPlaylist) =>
        userPlaylist.playlist != null && userPlaylist.playlist?.audioImportStatus == ProcessStatus.completed);
  }

  Future<void> _onPlaylistChanged(Playlist playlist) async {
    final state = this.state;

    final newState = await state.map((data) {
      return data.replace(
        (userPlaylist) => userPlaylist.playlistId == playlist.id,
        (userPlaylist) => userPlaylist.copyWith(playlist: playlist),
      );
    });

    emit(newState);
  }

  Future<void> _loadPlaylists() async {
    final userId = await _authUserInfoProvider.getId();
    if (userId == null) {
      Logger.root.warning('User is not authenticated, cannot load playlists');
      return;
    }

    emit(PlaylistListState.loading());

    final localPlaylists = await _userPlaylistLocalRepository.getAllByUserId(userId);

    emit(SimpleDataState.fromResult(localPlaylists));
  }
}
