import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/local_audio_file.dart';
import '../state/local_audio_files_state.dart';

class LocalAudioFiles extends StatelessWidget {
  const LocalAudioFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAudioFilesCubit, LocalAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          success: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => _Item(localAudioFile: data[index]),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.localAudioFile,
  });

  final LocalAudioFile localAudioFile;

  @override
  Widget build(BuildContext context) {
    return Text(localAudioFile.title);
  }
}
