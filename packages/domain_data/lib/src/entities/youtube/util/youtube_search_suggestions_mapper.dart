import 'package:sonify_client/sonify_client.dart';

import '../model/youtube_search_suggestions.dart';

final class YoutubeSearchSuggestionsMapper {
  YoutubeSearchSuggestions dtoToModel(YoutubeSearchSuggestionsDto dto) {
    return YoutubeSearchSuggestions(
      query: dto.query ?? '',
      suggestions: dto.suggestions ?? [],
    );
  }
}
