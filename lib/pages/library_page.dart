import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/audio/state/local_audio_files_state.dart';
import '../entities/audio/ui/local_audio_files.dart';
import '../features/download_file/ui/downloads_list.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocalAudioFilesCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    // return YoutubeVideoPage(args: YoutubeVideoPageArgs(videoId: 'W3q8Od5qJio'));
    return const CustomScrollView(
      slivers: [
        DownloadsList(),
        LocalAudioFiles(),
      ],
    );
  }
}
