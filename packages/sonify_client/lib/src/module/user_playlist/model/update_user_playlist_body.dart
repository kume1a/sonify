import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_playlist_body.g.dart';

part 'update_user_playlist_body.freezed.dart';

@freezed
class UpdateUserPlaylistBody with _$UpdateUserPlaylistBody {
  const factory UpdateUserPlaylistBody({
    String? name,
  }) = _UpdateUserPlaylistBody;

  factory UpdateUserPlaylistBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserPlaylistBodyFromJson(json);
}
