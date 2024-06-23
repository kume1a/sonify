import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/util/debounce.dart';
import '../../spotifyauth/api/spotify_access_token_provider.dart';

typedef SpotifySearchState = DataState<NetworkCallError, SpotifySearchResult>;

extension SpotifySearchCubitX on BuildContext {
  SpotifySearchCubit get spotifySearchCubit => read<SpotifySearchCubit>();
}

@injectable
class SpotifySearchCubit extends Cubit<SpotifySearchState> {
  SpotifySearchCubit(
    this._spotifyRemoteRepository,
    this._spotifyAccessTokenProvider,
  ) : super(SpotifySearchState.idle());

  final SpotifyRemoteRepository _spotifyRemoteRepository;
  final SpotifyAccessTokenProvider _spotifyAccessTokenProvider;

  final Debounce _debounce = Debounce.fromMilliseconds(400);

  Future<void> onSearchQueryChanged(String value) async {
    final spotifyAccessToken = await _spotifyAccessTokenProvider.get();
    if (spotifyAccessToken == null) {
      Logger.root.warning('SpotifySearchCubit.onSearchQueryChanged: Spotify access token is null');
      return;
    }

    _debounce.execute(() async {
      emit(SpotifySearchState.loading());

      final res = await _spotifyRemoteRepository.search(
        keyword: value,
        spotifyAccessToken: spotifyAccessToken,
      );

      emit(SpotifySearchState.fromEither(res));
    });
  }

  @override
  Future<void> close() {
    _debounce.dispose();

    return super.close();
  }

  Future<void> onSearchedPlaylistPressed(SpotifySearchResultPlaylist playlistSearchResult) async {
    Logger.root.info('onSearchedPlaylistPressed: $playlistSearchResult');
  }
}
