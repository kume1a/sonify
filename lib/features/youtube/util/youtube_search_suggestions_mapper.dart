import 'package:injectable/injectable.dart';

import '../model/youtube_search_suggestions.dart';
import '../model/youtube_search_suggestions_dto.dart';

@lazySingleton
class YoutubeSearchSuggestionsMapper {
  YoutubeSearchSuggestions jsonToModel(Map<String, dynamic> json) {
    final dto = YoutubeSearchSuggestionsDto.fromJson(json);

    return YoutubeSearchSuggestions(
      query: dto.query ?? '',
      suggestions: dto.suggestions ?? [],
    );
  }
}
