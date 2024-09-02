import 'dart:async';

import 'package:common_utilities/common_utilities.dart';
import 'package:sonify_client/sonify_client.dart';

import '../../../shared/constant.dart';
import '../../../shared/event_channel.dart';
import '../model/playlist.dart';
import '../util/playlist_mapper.dart';
import 'playlist_updated_event_channel.dart';

final class WsPlaylistUpdatedEventChannel extends WsEventChannel<Playlist>
    implements PlaylistUpdatedEventChannel {
  WsPlaylistUpdatedEventChannel(
    this._playlistMapper,
    DisposableProvider<SocketHolder> _socketHolderProvider,
  ) : super(_socketHolderProvider);

  final PlaylistMapper _playlistMapper;

  @override
  String get messageType => WSMessageType.playlistUpdated;

  @override
  FutureOr<Playlist> map(Map<String, dynamic> payload) {
    final dto = PlaylistDto.fromJson(payload);

    return _playlistMapper.dtoToModel(dto);
  }
}
