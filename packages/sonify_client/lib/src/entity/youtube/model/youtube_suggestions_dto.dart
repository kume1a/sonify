import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_suggestions_dto.g.dart';

part 'youtube_suggestions_dto.freezed.dart';

@freezed
class YoutubeSuggestionsDto with _$YoutubeSuggestionsDto {
  const factory YoutubeSuggestionsDto({
    String? query,
    List<String>? suggestions,
  }) = _YoutubeSuggestionsDto;

  factory YoutubeSuggestionsDto.fromJson(Map<String, dynamic> json) => _$YoutubeSuggestionsDtoFromJson(json);
}
