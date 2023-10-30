import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../model/youtube_music_home_dto.dart';
import '../state/youtube_home_videos_state.dart';

class YoutubeHomeVideos extends StatelessWidget {
  const YoutubeHomeVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeHomeVideosCubit, YoutubeHomeVideosState>(
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => _Success(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _Success extends StatelessWidget {
  const _Success(this.data);

  final YoutubeMusicHomeDto data;

  @override
  Widget build(BuildContext context) {
    Logger.root.info(json.encode(data));
    return ListView.builder(
      itemCount: data.body?.length ?? 0,
      itemBuilder: (_, index) {
        final body = data.body![index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(body.title ?? ''),
            for (final playlist in body.playlists ?? [])
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(playlist.title ?? ''),
              ),
          ],
        );
      },
    );
  }
}
