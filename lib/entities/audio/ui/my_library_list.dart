import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/my_library_audios_state.dart';
import 'local_user_audio_list_item.dart';

class MyLibraryList extends StatelessWidget {
  const MyLibraryList({
    super.key,
    this.itemPadding,
  });

  final EdgeInsets? itemPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyLibraryAudiosCubit, MyLibraryAudiosState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(),
          loading: () => const SliverToBoxAdapter(child: Center(child: SmallCircularProgressIndicator())),
          success: (data) => SliverList.builder(
            itemCount: data.length + 1,
            itemBuilder: (_, index) {
              if (index == data.length) {
                return SizedBox(height: AudioListItem.height + 12.h);
              }

              return LocalUserAudioListItem(
                userAudio: data[index],
                padding: itemPadding,
              );
            },
          ),
        );
      },
    );
  }
}
