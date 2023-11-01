import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_search_suggestions_dto.g.dart';

part 'youtube_search_suggestions_dto.freezed.dart';

@freezed
class YoutubeSearchSuggestionsDto with _$YoutubeSearchSuggestionsDto {
  const factory YoutubeSearchSuggestionsDto({
    String? query,
    List<String>? suggestions,
  }) = _YoutubeSearchSuggestionsDto;

  factory YoutubeSearchSuggestionsDto.fromJson(Map<String, dynamic> json) =>
      _$YoutubeSearchSuggestionsDtoFromJson(json);
}
