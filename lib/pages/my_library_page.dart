import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/di/register_dependencies.dart';
import '../entities/audio/state/my_library_audios_state.dart';
import '../entities/audio/ui/my_library_alphabet.dart';
import '../entities/audio/ui/my_library_list.dart';
import '../entities/playlist/ui/my_library_header.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/state/now_playing_audio_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../shared/ui/default_back_button.dart';
import '../shared/ui/list_item/audio_list_item.dart';
import '../shared/ui/search_container.dart';
import '../shared/values/assets.dart';

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
final _myLibraryHeaderHeght = MyLibraryHeader.height + _spacingAfterHeader;

class TileVisibilityInfo {
  const TileVisibilityInfo({
    required this.isVisible,
    required this.isAboveViewportCenter,
    required this.isBelowViewportCenter,
  });
  final bool isVisible;
  final bool isAboveViewportCenter;
  final bool isBelowViewportCenter;
}

class _Content extends HookWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final horizontalPadding = EdgeInsets.symmetric(horizontal: 16.w);

    final scrollController = useScrollController();
    final isAlphabetListVisible = useState(false);
    final nowPlayingAudioIndex = useState(-1);
    final nowPlayingAudioTileVisibilityInfo = useState<TileVisibilityInfo>(
      const TileVisibilityInfo(
        isVisible: false,
        isAboveViewportCenter: false,
        isBelowViewportCenter: false,
      ),
    );

    useEffect(
      () {
        void updateVisibility() {
          final viewportStartOffset = scrollController.offset;
          final viewportEndOffset = viewportStartOffset + scrollController.position.viewportDimension;
          final viewportCenterOffset = (viewportStartOffset + viewportEndOffset) / 2;

          final newIsAlphabetListVisible = viewportStartOffset >= _myLibraryHeaderHeght;
          if (isAlphabetListVisible.value != newIsAlphabetListVisible) {
            isAlphabetListVisible.value = newIsAlphabetListVisible;
          }

          if (nowPlayingAudioIndex.value != -1) {
            final nowPlayingAudioTileOffsetStart =
                _myLibraryHeaderHeght + nowPlayingAudioIndex.value * AudioListItem.height;
            final nowPlayingAudioTileOffsetEnd = nowPlayingAudioTileOffsetStart + AudioListItem.height;

            final newVisibilityInfo = TileVisibilityInfo(
              isVisible: nowPlayingAudioTileOffsetStart >= viewportStartOffset &&
                  nowPlayingAudioTileOffsetEnd <= viewportEndOffset,
              isAboveViewportCenter: nowPlayingAudioTileOffsetEnd < viewportCenterOffset,
              isBelowViewportCenter: nowPlayingAudioTileOffsetStart > viewportCenterOffset,
            );

            if (nowPlayingAudioTileVisibilityInfo.value != newVisibilityInfo) {
              nowPlayingAudioTileVisibilityInfo.value = newVisibilityInfo;
            }
          }
        }

        void onScroll() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            updateVisibility();
          });
        }

        scrollController.addListener(onScroll);

        return () {
          scrollController.removeListener(onScroll);
        };
      },
      [scrollController, nowPlayingAudioIndex],
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

                          final offsetToScroll = _myLibraryHeaderHeght + index * AudioListItem.height;

                          if (offsetToScroll > scrollController.position.maxScrollExtent - 20) {
                            scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            return;
                          }

                          scrollController.jumpTo(offsetToScroll);
                        },
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 150),
                      bottom: AudioPlayerPanel.minHeight + 10.h,
                      right: isAlphabetListVisible.value ? 24.w : 4.w,
                      child: BlocConsumer<NowPlayingAudioCubit, NowPlayingAudioState>(
                        buildWhen: (previous, current) => previous.nowPlayingAudio != current.nowPlayingAudio,
                        listenWhen: (previous, current) =>
                            previous.nowPlayingAudioIndex != current.nowPlayingAudioIndex,
                        listener: (_, state) {
                          nowPlayingAudioIndex.value = state.nowPlayingAudioIndex;
                        },
                        builder: (_, state) {
                          return ScrollToNowPlayingButton(
                            isAudioPlaying: state.nowPlayingAudio.maybeWhen(
                              orElse: () => false,
                              success: (_) => true,
                            ),
                            isVisible: nowPlayingAudioTileVisibilityInfo.value.isVisible,
                            isAboveViewportCenter:
                                nowPlayingAudioTileVisibilityInfo.value.isAboveViewportCenter,
                            scrollController: scrollController,
                            nowPlayingAudioIndex: nowPlayingAudioIndex,
                            myLibraryHeaderHeight: _myLibraryHeaderHeght,
                          );
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

class ScrollToNowPlayingButton extends StatelessWidget {
  const ScrollToNowPlayingButton({
    super.key,
    required this.isAudioPlaying,
    required this.isVisible,
    required this.isAboveViewportCenter,
    required this.scrollController,
    required this.nowPlayingAudioIndex,
    required this.myLibraryHeaderHeight,
  });

  final bool isAudioPlaying;
  final bool isVisible;
  final bool isAboveViewportCenter;
  final ScrollController scrollController;
  final ValueNotifier<int> nowPlayingAudioIndex;
  final double myLibraryHeaderHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isAudioPlaying && !isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          padding: EdgeInsets.zero,
        ),
        onPressed: _scrollToNowPlayingAudio,
        icon: RotatedBox(
          quarterTurns: isAboveViewportCenter ? 2 : 0,
          child: SvgPicture.asset(Assets.svgChevronDown),
        ),
      ),
    );
  }

  void _scrollToNowPlayingAudio() {
    final viewportHeight = scrollController.position.viewportDimension;
    final tileHeight = AudioListItem.height;
    final targetOffset =
        myLibraryHeaderHeight + nowPlayingAudioIndex.value * tileHeight - (viewportHeight - tileHeight) / 2;

    scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
