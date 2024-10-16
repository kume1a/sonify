import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/di/register_dependencies.dart';
import '../entities/audio/state/my_library_audios_state.dart';
import '../entities/audio/ui/my_library_alphabet.dart';
import '../entities/audio/ui/my_library_list.dart';
import '../entities/playlist/ui/my_library_header.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../shared/ui/default_back_button.dart';
import '../shared/ui/list_item/audio_list_item.dart';
import '../shared/ui/search_container.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MyLibraryAudiosCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
      ],
      child: const _Content(),
    );
  }
}

final _spacingAfterHeader = 12.h;
final _tilesAndHeaderHeght = MyLibraryHeader.height + _spacingAfterHeader;

class _Content extends HookWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = EdgeInsets.symmetric(horizontal: 16.w);

    final scrollController = useScrollController();
    final isAlphabetListVisible = useState(false);

    useEffect(
      () {
        scrollController.addListener(() {
          final offset = scrollController.offset;

          isAlphabetListVisible.value = offset >= _tilesAndHeaderHeght;
        });

        return null;
      },
      [scrollController],
    );

    return Scaffold(
      body: SafeArea(
        child: AudioPlayerPanel(
          body: Column(
            children: [
              Padding(
                padding: horizontalPadding.copyWith(left: 4.w, top: 20.h),
                child: Row(
                  children: [
                    const DefaultBackButton(),
                    Expanded(
                      child: SearchContainer(
                        onPressed: context.myLibraryAudiosCubit.onSearchContainerPressed,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator.adaptive(
                      onRefresh: context.myLibraryAudiosCubit.onRefresh,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverPadding(
                            padding: horizontalPadding,
                            sliver: const SliverToBoxAdapter(
                              child: MyLibraryHeader(),
                            ),
                          ),
                          SliverSizedBox(height: _spacingAfterHeader),
                          MyLibraryList(
                            itemPadding: EdgeInsets.only(
                              left: 16.r,
                              right: isAlphabetListVisible.value ? 20.r : 2.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isAlphabetListVisible.value ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: MyLibraryAlphabet(
                        onIndexChanged: (index) {
                          if (!scrollController.hasClients) {
                            return;
                          }

                          final offsetToScroll = _tilesAndHeaderHeght + index * AudioListItem.height;

                          if (offsetToScroll > scrollController.position.maxScrollExtent - 20) {
                            scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            return;
                          }

                          scrollController.jumpTo(offsetToScroll);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
