import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/audio/ui/local_user_audio_list_item.dart';
import '../../../shared/ui/list_item/audio_list_item.dart';
import '../../../shared/ui/small_circular_progress_indicator.dart';
import '../state/search_my_library_state.dart';

class SearchedMyLibraryList extends StatelessWidget {
  const SearchedMyLibraryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchMyLibraryCubit, SearchMyLibraryState>(
      builder: (_, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const Center(child: SmallCircularProgressIndicator()),
          success: (data) => ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (_, index) {
              if (index == data.length) {
                return SizedBox(height: AudioListItem.height + 12.h);
              }

              return LocalUserAudioListItem(
                userAudio: data[index],
                padding: EdgeInsets.symmetric(horizontal: 16.r),
              );
            },
          ),
        );
      },
    );
  }
}
