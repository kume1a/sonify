import 'package:domain_data/domain_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_user_playlist.freezed.dart';

@freezed
class EventUserPlaylist with _$EventUserPlaylist {
  const factory EventUserPlaylist.created(UserPlaylist userPlaylist) = _created;

  const factory EventUserPlaylist.updated(UserPlaylist userPlaylist) = _updated;

  const factory EventUserPlaylist.deleted(UserPlaylist userPlaylist) = _deleted;
}
