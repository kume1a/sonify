import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../features/spotifyauth/api/spotify_access_token_provider.dart';

@injectable
class SpotifyPlaylistListCubit extends Cubit<Unit> {
  SpotifyPlaylistListCubit(
    this._playlistRepository,
    this._spotifyAccessTokenProvider,
  ) : super(unit) {
    _init();
  }

  final PlaylistRepository _playlistRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;

  Future<void> _init() async {
    // final spotifyAccessToken = await _spotifyAccessTokenProvider.get();

    // if (spotifyAccessToken == null) {
    //   Logger.root.warning('Spotify access token is null');
    //   return;
    // }

    // await _playlistRepository.importSpotifyUserPlaylists(
    //   spotifyAccessToken: spotifyAccessToken,
    // );
  }
}
