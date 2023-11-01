import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/youtube_music_home_dto.dart';
import '../state/youtube_home_videos_state.dart';
import 'youtube_video_list_item.dart';

class YoutubeHomeVideos extends StatelessWidget {
  const YoutubeHomeVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideosCubit, YoutubeVideosState>(
      buildWhen: (previous, current) =>
          previous.musicHome != current.musicHome || previous.searchResults != current.searchResults,
      builder: (_, state) {
        if (!state.musicHome.isIdle) {
          return state.musicHome.maybeWhen(
            success: (data) => _MusicHomeSuccess(data),
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const SizedBox.shrink(),
          );
        }

        return state.searchResults.maybeWhen(
          success: (data) => _SearchResultsSuccess(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _MusicHomeSuccess extends StatelessWidget {
  const _MusicHomeSuccess(this.data);

  final YoutubeMusicHomeDto data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.body?.length ?? 0,
      itemBuilder: (_, index) {
        final body = data.body![index];

        if (body.playlists == null || body.playlists!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final playlist in body.playlists!)
              YoutubeVideoListItem(
                imageUrl: playlist.imageMedium,
                title: playlist.title ?? '',
              ),
          ],
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
    Logger.root.info(data);

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, index) {
        final video = data[index];

        return YoutubeVideoListItem(
          imageUrl: video.thumbnails.mediumResUrl,
          title: video.title,
        );
      },
    );
  }
}
