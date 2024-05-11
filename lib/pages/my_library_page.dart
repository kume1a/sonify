import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/di/register_dependencies.dart';
import '../app/intl/app_localizations.dart';
import '../entities/audio/state/local_audio_files_state.dart';
import '../entities/audio/ui/local_audio_files.dart';
import '../entities/audio/ui/local_audio_files_alphabet.dart';
import '../entities/playlist/ui/my_library_header.dart';
import '../entities/playlist/ui/my_library_tiles.dart';
import '../features/play_audio/state/audio_player_panel_state.dart';
import '../features/play_audio/ui/audio_player_panel.dart';
import '../shared/ui/default_back_button.dart';
import '../shared/ui/list_item/audio_list_item.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocalAudioFilesCubit>()),
        BlocProvider(create: (_) => getIt<AudioPlayerPanelCubit>()),
      ],
      child: const _Content(),
    );
  }
}

final _spacingAfterTiles = 20.h;
final _spacingAfterHeader = 12.h;
final _tilesAndHeaderHeght =
    MyLibraryTiles.tileHeight + _spacingAfterTiles + MyLibraryHeader.height + _spacingAfterHeader;

class _Content extends HookWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

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
                      child: TextField(
                        autocorrect: false,
                        onChanged: context.localAudioFilesCubit.onSearchQueryChanged,
                        decoration: InputDecoration(hintText: l.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Stack(
                  children: [
                    CustomScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: horizontalPadding,
                          sliver: const SliverToBoxAdapter(
                            child: MyLibraryTiles(),
                          ),
                        ),
                        SliverSizedBox(height: _spacingAfterTiles),
                        SliverPadding(
                          padding: horizontalPadding,
                          sliver: const SliverToBoxAdapter(
                            child: MyLibraryHeader(),
                          ),
                        ),
                        SliverSizedBox(height: _spacingAfterHeader),
                        LocalAudioFiles(
                          itemPadding: EdgeInsets.only(
                            left: 16.r,
                            right: isAlphabetListVisible.value ? 26.r : 16.r,
                          ),
                        ),
                        SliverSizedBox(height: AudioListItem.height + 12.h),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: isAlphabetListVisible.value ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: LocalAudioFilesAlphabet(
                        onIndexChanged: (index) {
                          if (!scrollController.hasClients ||
                              scrollController.offset > scrollController.position.maxScrollExtent - 20) {
                            return;
                          }

                          scrollController.jumpTo(_tilesAndHeaderHeght + index * AudioListItem.height);
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
