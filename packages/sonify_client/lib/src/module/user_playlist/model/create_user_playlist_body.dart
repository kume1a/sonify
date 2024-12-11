import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_playlist_body.g.dart';

part 'create_user_playlist_body.freezed.dart';

@freezed
class CreateUserPlaylistBody with _$CreateUserPlaylistBody {
  const factory CreateUserPlaylistBody({
    required String name,
  }) = _CreateUserPlaylistBody;

  factory CreateUserPlaylistBody.fromJson(Map<String, dynamic> json) =>
      _$CreateUserPlaylistBodyFromJson(json);
}
