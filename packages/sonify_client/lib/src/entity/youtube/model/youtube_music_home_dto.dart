import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_music_home_dto.g.dart';

part 'youtube_music_home_dto.freezed.dart';

@freezed
class YoutubeMusicHomeDto with _$YoutubeMusicHomeDto {
  const factory YoutubeMusicHomeDto({
    List<YoutubeMusicHomeBodyDto>? body,
    List<YoutubeMusicHomeHeadDto>? head,
  }) = _YoutubeMusicHomeDto;

  factory YoutubeMusicHomeDto.fromJson(Map<String, dynamic> json) => _$YoutubeMusicHomeDtoFromJson(json);
}

@freezed
class YoutubeMusicHomeBodyDto with _$YoutubeMusicHomeBodyDto {
  const factory YoutubeMusicHomeBodyDto({
    String? title,
    List<YoutubePlaylistDto>? playlists,
  }) = _YoutubeMusicHomeBodyDto;

  factory YoutubeMusicHomeBodyDto.fromJson(Map<String, dynamic> json) =>
      _$YoutubeMusicHomeBodyDtoFromJson(json);
}

@freezed
class YoutubePlaylistDto with _$YoutubePlaylistDto {
  const factory YoutubePlaylistDto({
    String? title,
    String? type,
    String? description,
    String? count,
    String? playlistId,
    String? firstItemId,
    String? image,
    String? imageMedium,
    String? imageStandard,
    String? imageMax,
  }) = _YoutubePlaylistDto;

  factory YoutubePlaylistDto.fromJson(Map<String, dynamic> json) => _$YoutubePlaylistDtoFromJson(json);
}

@freezed
class YoutubeMusicHomeHeadDto with _$YoutubeMusicHomeHeadDto {
  const factory YoutubeMusicHomeHeadDto({
    String? title,
    String? type,
    String? description,
    String? videoId,
    String? firstItemId,
    String? image,
    String? imageMedium,
    String? imageStandard,
    String? imageMax,
  }) = _YoutubeMusicHomeHeadDto;

  factory YoutubeMusicHomeHeadDto.fromJson(Map<String, dynamic> json) =>
      _$YoutubeMusicHomeHeadDtoFromJson(json);
}
