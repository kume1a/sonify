import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/local_user_audio_files_state.dart';
import 'local_user_audio_list_item.dart';

class MyLibraryList extends StatelessWidget {
  const MyLibraryList({
    super.key,
    this.itemPadding,
  });

  final EdgeInsets? itemPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalUserAudioFilesCubit, LocalUserAudioFilesState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: SmallCircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => LocalUserAudioListItem(
              audio: data[index],
              padding: itemPadding,
            ),
          ),
        );
      },
    );
  }
}
