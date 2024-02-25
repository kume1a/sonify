import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../state/youtube_videos_state.dart';
import 'youtube_video_list_item.dart';

class YoutubeHomeVideos extends StatelessWidget {
  const YoutubeHomeVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideosCubit, YoutubeVideosState>(
      buildWhen: (previous, current) => previous.searchResults != current.searchResults,
      builder: (_, state) {
        return state.searchResults.maybeWhen(
          success: (data) => _SearchResultsSuccess(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _SearchResultsSuccess extends StatelessWidget {
  const _SearchResultsSuccess(this.data);

  final List<Video> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final video = data[index];

          return YoutubeVideoListItem(
            videoId: video.id.value,
            imageUrl: video.thumbnails.mediumResUrl,
            title: video.title,
          );
        },
      ),
    );
  }
}
