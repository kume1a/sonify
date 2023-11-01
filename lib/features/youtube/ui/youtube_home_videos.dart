import 'dart:convert';

import 'package:common_widgets/common_widgets.dart';
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SafeImage(
                        url: playlist.image,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      playlist.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
