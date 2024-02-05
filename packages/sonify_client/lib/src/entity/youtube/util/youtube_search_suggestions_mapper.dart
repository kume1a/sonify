import '../model/youtube_search_suggestions.dart';
import '../model/youtube_suggestions_dto.dart';

final class YoutubeSearchSuggestionsMapper {
  YoutubeSearchSuggestions dtoToModel(YoutubeSuggestionsDto dto) {
    return YoutubeSearchSuggestions(
      query: dto.query ?? '',
      suggestions: dto.suggestions ?? [],
    );
  }
}
