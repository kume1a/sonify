import 'package:logging/logging.dart';

import '../model/youtube_music_home_dto.dart';

final class YoutubeMusicHomeDtoParser {
  YoutubeMusicHomeDto parse(Map<String, dynamic> json) {
    final List result = json['contents']['twoColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']
        ['content']['sectionListRenderer']['contents'] as List;

    final List headResult = json['header']['carouselHeaderRenderer']['contents'][0]['carouselItemRenderer']
        ['carouselItems'] as List;

    final List shelfRenderer = result.map((element) {
      return element['itemSectionRenderer']['contents'][0]['shelfRenderer'];
    }).toList();

    final List finalResult = shelfRenderer.map((element) {
      if (element['title']['runs'][0]['text'].trim() != 'Highlights from Global Citizen Live') {
        return {
          'title': element['title']['runs'][0]['text'],
          'playlists': element['title']['runs'][0]['text'].trim() == 'Charts'
              ? formatChartItems(
                  element['content']['horizontalListRenderer']['items'] as List,
                )
              : element['title']['runs'][0]['text'].toString().contains('Music Videos')
                  ? formatVideoItems(
                      element['content']['horizontalListRenderer']['items'] as List,
                    )
                  : formatItems(
                      element['content']['horizontalListRenderer']['items'] as List,
                    ),
        };
      } else {
        return null;
      }
    }).toList();

    final List finalHeadResult = formatHeadItems(headResult);
    finalResult.removeWhere((element) => element == null);

    return YoutubeMusicHomeDto.fromJson({'body': finalResult, 'head': finalHeadResult});
  }

  List formatChartItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridPlaylistRenderer']['title']['runs'][0]['text'],
          'type': 'chart',
          'description': e['gridPlaylistRenderer']['shortBylineText']['runs'][0]['text'],
          'count': e['gridPlaylistRenderer']['videoCountText']['runs'][0]['text'],
          'playlistId': e['gridPlaylistRenderer']['navigationEndpoint']['watchEndpoint']['playlistId'],
          'firstItemId': e['gridPlaylistRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'image': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageStandard': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMax': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      Logger.root.severe('Error in formatChartItems: $e');
      return List.empty();
    }
  }

  List formatVideoItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridVideoRenderer']['title']['simpleText'],
          'type': 'video',
          'description': e['gridVideoRenderer']['shortBylineText']['runs'][0]['text'],
          'count': e['gridVideoRenderer']['shortViewCountText']['simpleText'],
          'videoId': e['gridVideoRenderer']['videoId'],
          'firstItemId': e['gridVideoRenderer']['videoId'],
          'image': e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
          'imageMin': e['gridVideoRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['gridVideoRenderer']['thumbnail']['thumbnails'][1]['url'],
          'imageStandard': e['gridVideoRenderer']['thumbnail']['thumbnails'][2]['url'],
          'imageMax': e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      Logger.root.severe('Error in formatVideoItems: $e');
      return List.empty();
    }
  }

  List formatItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['compactStationRenderer']['title']['simpleText'],
          'type': 'playlist',
          'description': e['compactStationRenderer']['description']['simpleText'],
          'count': e['compactStationRenderer']['videoCountText']['runs'][0]['text'],
          'playlistId': e['compactStationRenderer']['navigationEndpoint']['watchEndpoint']['playlistId'],
          'firstItemId': e['compactStationRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'image': e['compactStationRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['compactStationRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageStandard': e['compactStationRenderer']['thumbnail']['thumbnails'][1]['url'],
          'imageMax': e['compactStationRenderer']['thumbnail']['thumbnails'][2]['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      Logger.root.severe('Error in formatItems: $e');
      return List.empty();
    }
  }

  List formatHeadItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['defaultPromoPanelRenderer']['title']['runs'][0]['text'],
          'type': 'video',
          'description': (e['defaultPromoPanelRenderer']['description']['runs'] as List)
              .map((e) => e['text'])
              .toList()
              .join(),
          'videoId': e['defaultPromoPanelRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'firstItemId': e['defaultPromoPanelRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'image': e['defaultPromoPanelRenderer']['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']['thumbnails']
              .last['url'],
          'imageMedium': e['defaultPromoPanelRenderer']['largeFormFactorBackgroundThumbnail']
              ['thumbnailLandscapePortraitRenderer']['landscape']['thumbnails'][1]['url'],
          'imageStandard': e['defaultPromoPanelRenderer']['largeFormFactorBackgroundThumbnail']
              ['thumbnailLandscapePortraitRenderer']['landscape']['thumbnails'][2]['url'],
          'imageMax': e['defaultPromoPanelRenderer']['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']['thumbnails']
              .last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      Logger.root.severe('Error in formatHeadItems: $e');
      return List.empty();
    }
  }
}
