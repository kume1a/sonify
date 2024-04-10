import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_search_suggestions.freezed.dart';

@freezed
class YoutubeSearchSuggestions with _$YoutubeSearchSuggestions {
  const factory YoutubeSearchSuggestions({
    required String query,
    required List<String> suggestions,
  }) = _YoutubeSearchSuggestions;

  const YoutubeSearchSuggestions._();

  factory YoutubeSearchSuggestions.empty() {
    return const YoutubeSearchSuggestions(
      query: '',
      suggestions: [],
    );
  }
}
