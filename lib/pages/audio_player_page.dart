import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../app/intl/app_localizations.dart';
import 'temp/collage.dart';
import 'temp/ext_storage.dart';
import 'temp/playlist.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final String gradientType = 'halfDark';
  final PanelController _panelController = PanelController();
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  late Duration _time;
  final gradientColor = ValueNotifier<List<Color?>?>([]);
  final cardKey = GlobalKey<FlipCardState>();

  void sleepTimer(int time) {
    audioHandler.customAction('sleepTimer', {'time': time});
  }

  void sleepCounter(int count) {
    audioHandler.customAction('sleepCounter', {'count': count});
  }

  Future<dynamic> setTimer(
    BuildContext context,
    BuildContext? scaffoldContext,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              AppLocalizations.of(context).selectDur,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    primaryColor: Theme.of(context).colorScheme.secondary,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    onTimerDurationChanged: (value) {
                      _time = value;
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    sleepTimer(0);
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context).cancel,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor:
                        Theme.of(context).colorScheme.secondary == Colors.white ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    sleepTimer(_time.inMinutes);
                    Navigator.pop(context);
                    // ShowSnackBar().showSnackBar(
                    //   context,
                    //   '${AppLocalizations.of(context).sleepTimerSetFor} ${_time.inMinutes} ${AppLocalizations.of(context).minutes}',
                    // );
                  },
                  child: Text(AppLocalizations.of(context).ok),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> setCounter() async {
    await showTextInputDialog(
      context: context,
      title: AppLocalizations.of(context).enterSongsCount,
      initialText: '',
      keyboardType: TextInputType.number,
      onSubmitted: (String value) {
        sleepCounter(
          int.parse(value),
        );
        Navigator.pop(context);
        // ShowSnackBar().showSnackBar(
        //   context,
        //   '${AppLocalizations.of(context).sleepTimerSetFor} $value ${AppLocalizations.of(context).songs}',
        // );
      },
    );
  }

  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  String format(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}: '.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    BuildContext? scaffoldContext;

    return Dismissible(
      direction: DismissDirection.down,
      background: const ColoredBox(color: Colors.transparent),
      key: const Key('playScreen'),
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final MediaItem? mediaItem = snapshot.data;
          if (mediaItem == null) {
            return const SizedBox();
          }
          final offline = !mediaItem.extras!['url'].toString().startsWith('http');
          mediaItem.artUri.toString().startsWith('file')
              ? getColors(
                  imageProvider: FileImage(
                    File(
                      mediaItem.artUri!.toFilePath(),
                    ),
                  ),
                  // useDominantAndDarkerColors: gradientType == 'halfLight' ||
                  //     gradientType == 'fullLight' ||
                  //     gradientType == 'fullMix',
                ).then((value) => updateBackgroundColors(value))
              : getColors(
                  imageProvider: CachedNetworkImageProvider(
                    mediaItem.artUri.toString(),
                  ),
                  // useDominantAndDarkerColors: gradientType == 'halfLight' ||
                  //     gradientType == 'fullLight' ||
                  //     gradientType == 'fullMix',
                ).then((value) => updateBackgroundColors(value));
          return ValueListenableBuilder(
            valueListenable: gradientColor,
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.expand_more_rounded),
                    tooltip: AppLocalizations.of(context).back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.lyrics_rounded),
                      //     Image.asset(
                      //   'assets/lyrics.png',
                      // ),
                      tooltip: AppLocalizations.of(context).lyrics,
                      // onPressed: () => cardKey.currentState!.toggleCard(),
                      onPressed: null,
                    ),
                    if (!offline)
                      IconButton(
                        icon: const Icon(Icons.share_rounded),
                        tooltip: AppLocalizations.of(context).share,
                        onPressed: () {
                          // Share.share(
                          //   mediaItem.extras!['perma_url'].toString(),
                          // );
                        },
                      ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      onSelected: (int? value) {
                        if (value == 10) {
                          final Map details = MediaItemConverter.mediaItemToMap(mediaItem);
                          details['duration'] =
                              '${int.parse(details["duration"].toString()) ~/ 60}:${int.parse(details["duration"].toString()) % 60}';
                          // style: Theme.of(context).textTheme.caption,
                          if (mediaItem.extras?['size'] != null) {
                            details.addEntries([
                              MapEntry(
                                'date_modified',
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                        mediaItem.extras!['date_modified'].toString(),
                                      ) *
                                      1000,
                                ).toString().split('.').first,
                              ),
                              MapEntry(
                                'size',
                                '${((mediaItem.extras!['size'] as int) / (1024 * 1024)).toStringAsFixed(2)} MB',
                              ),
                            ]);
                          }
                          PopupDialog().showPopup(
                            context: context,
                            child: GradientCard(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: details.keys.map((e) {
                                    return SelectableText.rich(
                                      TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: format(
                                              e.toString(),
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).textTheme.bodyLarge!.color,
                                            ),
                                          ),
                                          TextSpan(
                                            text: details[e].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      showCursor: true,
                                      cursorColor: Colors.black,
                                      cursorRadius: const Radius.circular(5),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        }
                        // if (value == 5) {
                        //   Navigator.push(
                        //     context,
                        //     PageRouteBuilder(
                        //       opaque: false,
                        //       pageBuilder: (_, __, ___) => SongsListPage(
                        //         listItem: {
                        //           'type': 'album',
                        //           'id': mediaItem.extras?['album_id'],
                        //           'title': mediaItem.album,
                        //           'image': mediaItem.artUri,
                        //         },
                        //       ),
                        //     ),
                        //   );
                        // }
                        // if (value == 4) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return const Equalizer();
                        //     },
                        //   );
                        // }
                        // if (value == 3) {
                        //   launchUrl(
                        //     Uri.parse(
                        //       mediaItem.genre == 'YouTube'
                        //           ? 'https://youtube.com/watch?v=${mediaItem.id}'
                        //           : 'https://www.youtube.com/results?search_query=${mediaItem.title} by ${mediaItem.artist}',
                        //     ),
                        //     mode: LaunchMode.externalApplication,
                        //   );
                        // }
                        if (value == 1) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                title: Text(
                                  AppLocalizations.of(context).sleepTimer,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                                children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context).sleepDur,
                                    ),
                                    subtitle: Text(
                                      AppLocalizations.of(context).sleepDurSub,
                                    ),
                                    dense: true,
                                    onTap: () {
                                      Navigator.pop(context);
                                      setTimer(
                                        context,
                                        scaffoldContext,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context).sleepAfter,
                                    ),
                                    subtitle: Text(
                                      AppLocalizations.of(context).sleepAfterSub,
                                    ),
                                    dense: true,
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.pop(context);
                                      setCounter();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (value == 0) {
                          AddToPlaylist().addToPlaylist(context, mediaItem);
                        }
                      },
                      itemBuilder: (context) => offline
                          ? [
                              if (mediaItem.extras?['album_id'] != null)
                                PopupMenuItem(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.album_rounded,
                                        color: Theme.of(context).iconTheme.color,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        AppLocalizations.of(context).viewAlbum,
                                      ),
                                    ],
                                  ),
                                ),
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.timer,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).sleepTimer,
                                    ),
                                  ],
                                ),
                              ),
                              // if (supportEqualizer)
                              PopupMenuItem(
                                value: 4,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.equalizer_rounded,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).equalizer,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 10,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_rounded,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).songInfo,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : [
                              if (mediaItem.extras?['album_id'] != null)
                                PopupMenuItem(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.album_rounded,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        AppLocalizations.of(context).viewAlbum,
                                      ),
                                    ],
                                  ),
                                ),
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.playlist_add_rounded,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).addToPlaylist,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.timer,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).sleepTimer,
                                    ),
                                  ],
                                ),
                              ),
                              // if (supportEqualizer)
                              PopupMenuItem(
                                value: 4,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.equalizer_rounded,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).equalizer,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Row(
                                  children: [
                                    // Icon(
                                    //   MdiIcons.youtube,
                                    //   color: Theme.of(context).iconTheme.color,
                                    // ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      mediaItem.genre == 'YouTube'
                                          ? AppLocalizations.of(
                                              context,
                                            ).watchVideo
                                          : AppLocalizations.of(
                                              context,
                                            ).searchVideo,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 10,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_rounded,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      AppLocalizations.of(context).songInfo,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                    ),
                  ],
                ),
                body: LayoutBuilder(
                  builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    if (constraints.maxWidth > constraints.maxHeight) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Artwork
                          ArtWorkWidget(
                            cardKey: cardKey,
                            mediaItem: mediaItem,
                            width: min(
                              constraints.maxHeight / 0.9,
                              constraints.maxWidth / 1.8,
                            ),
                            audioHandler: audioHandler,
                            offline: offline,
                            getLyricsOnline: true,
                          ),

                          // title and controls
                          NameNControls(
                            mediaItem: mediaItem,
                            offline: offline,
                            width: constraints.maxWidth / 2,
                            height: constraints.maxHeight,
                            panelController: _panelController,
                            audioHandler: audioHandler,
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        // Artwork
                        ArtWorkWidget(
                          cardKey: cardKey,
                          mediaItem: mediaItem,
                          width: constraints.maxWidth,
                          audioHandler: audioHandler,
                          offline: offline,
                          getLyricsOnline: true,
                        ),

                        // title and controls
                        NameNControls(
                          mediaItem: mediaItem,
                          offline: offline,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight - (constraints.maxWidth * 0.85),
                          panelController: _panelController,
                          audioHandler: audioHandler,
                        ),
                      ],
                    );
                  },
                ),
                // }
              ),
            ),
            builder: (BuildContext context, List<Color?>? value, Widget? child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: gradientType == 'simple' ? Alignment.topLeft : Alignment.topCenter,
                    end: gradientType == 'simple'
                        ? Alignment.bottomRight
                        : (gradientType == 'halfLight' || gradientType == 'halfDark')
                            ? Alignment.center
                            : Alignment.bottomCenter,
                    colors: gradientType == 'simple'
                        ? Theme.of(context).brightness == Brightness.dark
                            // ? currentTheme.getBackGradient()
                            ? [
                                const Color(0xfff5f9ff),
                                Colors.white,
                              ]
                            : [
                                const Color(0xfff5f9ff),
                                Colors.white,
                              ]
                        : Theme.of(context).brightness == Brightness.dark
                            ? [
                                if (gradientType == 'halfDark' || gradientType == 'fullDark')
                                  value?[1] ?? Colors.grey[900]!
                                else
                                  value?[0] ?? Colors.grey[900]!,
                                if (gradientType == 'fullMix') value?[1] ?? Colors.black else Colors.black,
                              ]
                            : [
                                value?[0] ?? const Color(0xfff5f9ff),
                                Colors.white,
                              ],
                  ),
                ),
                child: child,
              );
            },
          );
          // );
        },
      ),
    );
  }
}

class MediaState {
  MediaState(this.mediaItem, this.position);
  final MediaItem? mediaItem;
  final Duration position;
}

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class QueueState {
  const QueueState(
    this.queue,
    this.queueIndex,
    this.shuffleIndices,
    this.repeatMode,
  );
  static const QueueState empty = QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  bool get hasPrevious => repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext => repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices => shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class ControlButtons extends StatelessWidget {
  const ControlButtons(
    this.audioHandler, {
    super.key,
    this.shuffle = false,
    this.miniplayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
    this.dominantColor,
  });
  final AudioPlayerHandler audioHandler;
  final bool shuffle;
  final bool miniplayer;
  final List buttons;
  final Color? dominantColor;

  @override
  Widget build(BuildContext context) {
    final MediaItem mediaItem = audioHandler.mediaItem.value!;
    final bool online = mediaItem.extras!['url'].toString().startsWith('http');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Like':
            return !online
                ? const SizedBox()
                : LikeButton(
                    mediaItem: mediaItem,
                    size: 22.0,
                  );
          case 'Previous':
            return StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: miniplayer ? 24.0 : 45.0,
                  tooltip: AppLocalizations.of(context).skipPrevious,
                  color: dominantColor ?? Theme.of(context).iconTheme.color,
                  onPressed: queueState?.hasPrevious ?? true ? audioHandler.skipToPrevious : null,
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              height: miniplayer ? 40.0 : 65.0,
              width: miniplayer ? 40.0 : 65.0,
              child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing ?? true;
                  return Stack(
                    children: [
                      if (processingState == AudioProcessingState.loading ||
                          processingState == AudioProcessingState.buffering)
                        Center(
                          child: SizedBox(
                            height: miniplayer ? 40.0 : 65.0,
                            width: miniplayer ? 40.0 : 65.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).iconTheme.color!,
                              ),
                            ),
                          ),
                        ),
                      if (miniplayer)
                        Center(
                          child: playing
                              ? IconButton(
                                  tooltip: AppLocalizations.of(context).pause,
                                  onPressed: audioHandler.pause,
                                  icon: const Icon(
                                    Icons.pause_rounded,
                                  ),
                                  color: Theme.of(context).iconTheme.color,
                                )
                              : IconButton(
                                  tooltip: AppLocalizations.of(context).play,
                                  onPressed: audioHandler.play,
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                  ),
                                  color: Theme.of(context).iconTheme.color,
                                ),
                        )
                      else
                        Center(
                          child: SizedBox(
                            height: 59,
                            width: 59,
                            child: Center(
                              child: playing
                                  ? FloatingActionButton(
                                      elevation: 10,
                                      tooltip: AppLocalizations.of(context).pause,
                                      backgroundColor: Colors.white,
                                      onPressed: audioHandler.pause,
                                      child: const Icon(
                                        Icons.pause_rounded,
                                        size: 40.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  : FloatingActionButton(
                                      elevation: 10,
                                      tooltip: AppLocalizations.of(context).play,
                                      backgroundColor: Colors.white,
                                      onPressed: audioHandler.play,
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 40.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          case 'Next':
            return StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: miniplayer ? 24.0 : 45.0,
                  tooltip: AppLocalizations.of(context).skipNext,
                  color: dominantColor ?? Theme.of(context).iconTheme.color,
                  onPressed: queueState?.hasNext ?? true ? audioHandler.skipToNext : null,
                );
              },
            );
          case 'Download':
            return !online
                ? const SizedBox()
                : DownloadButton(
                    size: 20.0,
                    icon: 'download',
                    data: MediaItemConverter.mediaItemToMap(mediaItem),
                  );
          default:
            break;
        }
        return const SizedBox();
      }).toList(),
    );
  }
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
}

class NowPlayingStream extends StatelessWidget {
  const NowPlayingStream({
    super.key,
    required this.audioHandler,
    this.scrollController,
    this.panelController,
    this.head = false,
    this.headHeight = 50,
  });
  final AudioPlayerHandler audioHandler;
  final ScrollController? scrollController;
  final PanelController? panelController;
  final bool head;
  final double headHeight;

  void _updateScrollController(
    ScrollController? controller,
    int itemIndex,
    int queuePosition,
    int queueLength,
  ) {
    if (panelController != null && !panelController!.isPanelOpen) {
      if (queuePosition > 3) {
        controller?.animateTo(
          itemIndex * 72 + 12,
          curve: Curves.linear,
          duration: const Duration(
            milliseconds: 350,
          ),
        );
      } else if (queuePosition < 4 && queueLength > 4) {
        controller?.animateTo(
          (queueLength - 4) * 72 + 12,
          curve: Curves.linear,
          duration: const Duration(
            milliseconds: 350,
          ),
        );
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;
        final int queueStateIndex = queueState.queueIndex ?? 0;
        final num queuePosition = queue.length - queueStateIndex;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _updateScrollController(
            scrollController,
            queueState.queueIndex ?? 0,
            queuePosition.toInt(),
            queue.length,
          ),
        );

        return ReorderableListView.builder(
          header: SizedBox(
            height: head ? headHeight : 0,
          ),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            audioHandler.moveQueueItem(oldIndex, newIndex);
          },
          scrollController: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: queue.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(queue[index].id),
              direction: index == queueState.queueIndex ? DismissDirection.none : DismissDirection.horizontal,
              onDismissed: (dir) {
                audioHandler.removeQueueItemAt(index);
              },
              child: ListTileTheme(
                selectedColor: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 16.0, right: 10.0),
                  selected: index == queueState.queueIndex,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: (index == queueState.queueIndex)
                        ? [
                            IconButton(
                              icon: const Icon(
                                Icons.bar_chart_rounded,
                              ),
                              tooltip: AppLocalizations.of(context).playing,
                              onPressed: () {},
                            ),
                          ]
                        : [
                            if (queue[index].extras!['url'].toString().startsWith('http')) ...[
                              LikeButton(
                                mediaItem: queue[index],
                              ),
                              DownloadButton(
                                icon: 'download',
                                size: 25.0,
                                data: {
                                  'id': queue[index].id,
                                  'artist': queue[index].artist.toString(),
                                  'album': queue[index].album.toString(),
                                  'image': queue[index].artUri.toString(),
                                  'duration': queue[index].duration!.inSeconds.toString(),
                                  'title': queue[index].title,
                                  'url': queue[index].extras?['url'].toString(),
                                  'year': queue[index].extras?['year'].toString(),
                                  'language': queue[index].extras?['language'].toString(),
                                  'genre': queue[index].genre?.toString(),
                                  '320kbps': queue[index].extras?['320kbps'],
                                  'has_lyrics': queue[index].extras?['has_lyrics'],
                                  'release_date': queue[index].extras?['release_date'],
                                  'album_id': queue[index].extras?['album_id'],
                                  'subtitle': queue[index].extras?['subtitle'],
                                  'perma_url': queue[index].extras?['perma_url'],
                                },
                              ),
                            ],
                            ReorderableDragStartListener(
                              key: Key(queue[index].id),
                              index: index,
                              enabled: index != queueState.queueIndex,
                              child: const Icon(Icons.drag_handle_rounded),
                            ),
                          ],
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (queue[index].extras?['addedByAutoplay'] as bool? ?? false)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    AppLocalizations.of(context).addedBy,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 5.0,
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    AppLocalizations.of(context).autoplay,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (queue[index].artUri == null)
                            ? const SizedBox.square(
                                dimension: 50,
                                child: Image(
                                  image: AssetImage('assets/cover.jpg'),
                                ),
                              )
                            : SizedBox.square(
                                dimension: 50,
                                child: queue[index].artUri.toString().startsWith('file:')
                                    ? Image(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          File(
                                            queue[index].artUri!.toFilePath(),
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        errorWidget: (BuildContext context, _, __) => const Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'assets/cover.jpg',
                                          ),
                                        ),
                                        placeholder: (BuildContext context, _) => const Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'assets/cover.jpg',
                                          ),
                                        ),
                                        imageUrl: queue[index].artUri.toString(),
                                      ),
                              ),
                      ),
                    ],
                  ),
                  title: Text(
                    queue[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: index == queueState.queueIndex ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    queue[index].artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    audioHandler.skipToQueueItem(index);
                    _updateScrollController(
                      scrollController,
                      queueState.queueIndex ?? 0,
                      queuePosition.toInt(),
                      queue.length,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ArtWorkWidget extends StatefulWidget {
  const ArtWorkWidget({
    super.key,
    required this.cardKey,
    required this.mediaItem,
    required this.width,
    this.offline = false,
    required this.getLyricsOnline,
    required this.audioHandler,
  });
  final GlobalKey<FlipCardState> cardKey;
  final MediaItem mediaItem;
  final bool offline;
  final bool getLyricsOnline;
  final double width;
  final AudioPlayerHandler audioHandler;

  @override
  _ArtWorkWidgetState createState() => _ArtWorkWidgetState();
}

class _ArtWorkWidgetState extends State<ArtWorkWidget> {
  final ValueNotifier<bool> dragging = ValueNotifier<bool>(false);
  final ValueNotifier<bool> tapped = ValueNotifier<bool>(false);
  final ValueNotifier<bool> done = ValueNotifier<bool>(false);
  Map lyrics = {'id': '', 'lyrics': ''};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.width * 0.85,
      width: widget.width * 0.85,
      child: Hero(
        tag: 'currentArtwork',
        child: FlipCard(
          key: widget.cardKey,
          flipOnTouch: false,
          onFlipDone: (value) {
            if (lyrics['id'] != widget.mediaItem.id || (!value && lyrics['lyrics'] == '' && !done.value)) {
              done.value = false;
              if (widget.offline) {
                Lyrics.getOffLyrics(
                  widget.mediaItem.extras!['url'].toString(),
                ).then((value) {
                  if (value == '' && widget.getLyricsOnline) {
                    Lyrics.getLyrics(
                      id: widget.mediaItem.id,
                      saavnHas: widget.mediaItem.extras?['has_lyrics'] == 'true',
                      title: widget.mediaItem.title,
                      artist: widget.mediaItem.artist.toString(),
                    ).then((value) {
                      lyrics['lyrics'] = value;
                      lyrics['id'] = widget.mediaItem.id;
                      done.value = true;
                    });
                  } else {
                    lyrics['lyrics'] = value;
                    lyrics['id'] = widget.mediaItem.id;
                    done.value = true;
                  }
                });
              } else {
                Lyrics.getLyrics(
                  id: widget.mediaItem.id,
                  saavnHas: widget.mediaItem.extras?['has_lyrics'] == 'true',
                  title: widget.mediaItem.title,
                  artist: widget.mediaItem.artist.toString(),
                ).then((value) {
                  lyrics['lyrics'] = value;
                  lyrics['id'] = widget.mediaItem.id;
                  done.value = true;
                });
              }
            }
          },
          back: GestureDetector(
            onTap: () => widget.cardKey.currentState!.toggleCard(),
            onDoubleTap: () => widget.cardKey.currentState!.toggleCard(),
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: done,
                        child: const CircularProgressIndicator(),
                        builder: (
                          BuildContext context,
                          bool value,
                          Widget? child,
                        ) {
                          return value
                              ? lyrics['lyrics'] == ''
                                  ? emptyScreen(
                                      context,
                                      0,
                                      ':( ',
                                      100.0,
                                      AppLocalizations.of(context).lyrics,
                                      60.0,
                                      AppLocalizations.of(context).notAvailable,
                                      20.0,
                                      useWhite: true,
                                    )
                                  : SelectableText(
                                      lyrics['lyrics'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    )
                              : child!;
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      tooltip: AppLocalizations.of(context).copy,
                      onPressed: () {
                        Feedback.forLongPress(context);
                        copyToClipboard(
                          context: context,
                          text: lyrics['lyrics'].toString(),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded),
                      color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          front: StreamBuilder<QueueState>(
            stream: widget.audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data ?? QueueState.empty;

              // ignore: prefer_const_declarations
              var enableGesture = true;

              return Stack(
                children: [
                  GestureDetector(
                    onTap: !enableGesture
                        ? null
                        : () {
                            tapped.value = true;
                            Future.delayed(const Duration(seconds: 2), () async {
                              tapped.value = false;
                            });
                          },
                    onDoubleTap: !enableGesture
                        ? null
                        : () {
                            Feedback.forLongPress(context);
                            widget.cardKey.currentState!.toggleCard();
                          },
                    onHorizontalDragEnd: !enableGesture
                        ? null
                        : (DragEndDetails details) {
                            if ((details.primaryVelocity ?? 0) > 100) {
                              if (queueState.hasPrevious) {
                                widget.audioHandler.skipToPrevious();
                              }
                            }

                            if ((details.primaryVelocity ?? 0) < -100) {
                              if (queueState.hasNext) {
                                widget.audioHandler.skipToNext();
                              }
                            }
                          },
                    onLongPress: !enableGesture
                        ? null
                        : () {
                            if (!widget.offline) {
                              Feedback.forLongPress(context);
                              AddToPlaylist().addToPlaylist(context, widget.mediaItem);
                            }
                          },
                    onVerticalDragStart: !enableGesture
                        ? null
                        : (_) {
                            dragging.value = true;
                          },
                    onVerticalDragEnd: !enableGesture
                        ? null
                        : (_) {
                            dragging.value = false;
                          },
                    onVerticalDragUpdate: !enableGesture
                        ? null
                        : (DragUpdateDetails details) {
                            if (details.delta.dy != 0.0) {
                              double volume = widget.audioHandler.volume.value;
                              volume -= details.delta.dy / 150;
                              if (volume < 0) {
                                volume = 0;
                              }
                              if (volume > 1.0) {
                                volume = 1.0;
                              }
                              widget.audioHandler.setVolume(volume);
                            }
                          },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: widget.mediaItem.artUri.toString().startsWith('file')
                              ? Image(
                                  fit: BoxFit.contain,
                                  width: widget.width * 0.85,
                                  gaplessPlayback: true,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace,
                                  ) {
                                    return const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/cover.jpg'),
                                    );
                                  },
                                  image: FileImage(
                                    File(
                                      widget.mediaItem.artUri!.toFilePath(),
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  errorWidget: (BuildContext context, _, __) => const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/cover.jpg'),
                                  ),
                                  placeholder: (BuildContext context, _) => const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/cover.jpg'),
                                  ),
                                  imageUrl: widget.mediaItem.artUri.toString(),
                                  width: widget.width * 0.85,
                                ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: dragging,
                          child: StreamBuilder<double>(
                            stream: widget.audioHandler.volume,
                            builder: (context, snapshot) {
                              final double volumeValue = snapshot.data ?? 1.0;
                              return Center(
                                child: SizedBox(
                                  width: 60.0,
                                  height: widget.width * 0.7,
                                  child: Card(
                                    color: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: RotatedBox(
                                              quarterTurns: -1,
                                              child: SliderTheme(
                                                data: SliderTheme.of(context).copyWith(
                                                  thumbShape: HiddenThumbComponentShape(),
                                                  activeTrackColor: Theme.of(context).colorScheme.secondary,
                                                  inactiveTrackColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                      .withOpacity(0.4),
                                                  trackShape: const RoundedRectSliderTrackShape(),
                                                ),
                                                child: ExcludeSemantics(
                                                  child: Slider(
                                                    value: widget.audioHandler.volume.value,
                                                    onChanged: (_) {},
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 20.0,
                                          ),
                                          child: Icon(
                                            volumeValue == 0
                                                ? Icons.volume_off_rounded
                                                : volumeValue > 0.6
                                                    ? Icons.volume_up_rounded
                                                    : Icons.volume_down_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          builder: (
                            BuildContext context,
                            bool value,
                            Widget? child,
                          ) {
                            return Visibility(
                              visible: value,
                              child: child!,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: tapped,
                    child: GestureDetector(
                      onTap: () {
                        tapped.value = false;
                      },
                      child: Card(
                        color: Colors.black26,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: IconButton(
                                    tooltip: AppLocalizations.of(context).songInfo,
                                    onPressed: () {
                                      final Map details = MediaItemConverter.mediaItemToMap(
                                        widget.mediaItem,
                                      );
                                      details['duration'] =
                                          '${int.parse(details["duration"].toString()) ~/ 60}:${int.parse(details["duration"].toString()) % 60}';
                                      // style: Theme.of(context).textTheme.caption,
                                      if (widget.mediaItem.extras?['size'] != null) {
                                        details.addEntries([
                                          MapEntry(
                                            'date_modified',
                                            DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                    widget.mediaItem.extras!['date_modified'].toString(),
                                                  ) *
                                                  1000,
                                            ).toString().split('.').first,
                                          ),
                                          MapEntry(
                                            'size',
                                            '${((widget.mediaItem.extras!['size'] as int) / (1024 * 1024)).toStringAsFixed(2)} MB',
                                          ),
                                        ]);
                                      }
                                      PopupDialog().showPopup(
                                        context: context,
                                        child: GradientCard(
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(25.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: details.keys.map((e) {
                                                return SelectableText.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '${e[0].toUpperCase()}${e.substring(1)}: '
                                                            .replaceAll(
                                                          '_',
                                                          ' ',
                                                        ),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: details[e].toString(),
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  showCursor: true,
                                                  cursorColor: Colors.black,
                                                  cursorRadius: const Radius.circular(5),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.info_rounded),
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: IconButton(
                                    tooltip: AppLocalizations.of(context).addToPlaylist,
                                    onPressed: () {
                                      AddToPlaylist().addToPlaylist(
                                        context,
                                        widget.mediaItem,
                                      );
                                    },
                                    icon: const Icon(Icons.playlist_add_rounded),
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    builder: (context, bool value, Widget? child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Visibility(visible: value, child: child!),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NameNControls extends StatelessWidget {
  const NameNControls({
    super.key,
    required this.width,
    required this.height,
    required this.mediaItem,
    // required this.gradientColor,
    required this.audioHandler,
    required this.panelController,
    this.offline = false,
  });
  final MediaItem mediaItem;
  final bool offline;
  final double width;
  final double height;
  // final List<Color?>? gradientColor;
  final PanelController panelController;
  final AudioPlayerHandler audioHandler;

  Stream<Duration> get _bufferedPositionStream =>
      audioHandler.playbackState.map((state) => state.bufferedPosition).distinct();
  Stream<Duration?> get _durationStream => audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        _durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    final double titleBoxHeight = height * 0.25;
    final double seekBoxHeight = height > 500 ? height * 0.15 : height * 0.2;
    final double controlBoxHeight = offline
        ? height > 500
            ? height * 0.2
            : height * 0.25
        : (height < 350
            ? height * 0.4
            : height > 500
                ? height * 0.2
                : height * 0.3);
    final double nowplayingBoxHeight = height > 500 ? height * 0.4 : height * 0.15;
    // ignore: prefer_const_declarations
    final bool useFullScreenGradient = false;
    final List<String> artists = mediaItem.artist.toString().split(', ');
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// Title and subtitle
              SizedBox(
                height: titleBoxHeight,
                child: PopupMenuButton<String>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  offset: const Offset(1.0, 0.0),
                  onSelected: (String value) {
                    // if (value == '0') {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       opaque: false,
                    //       pageBuilder: (_, __, ___) => SongsListPage(
                    //         listItem: {
                    //           'type': 'album',
                    //           'id': mediaItem.extras?['album_id'],
                    //           'title': mediaItem.album,
                    //           'image': mediaItem.artUri,
                    //         },
                    //       ),
                    //     ),
                    //   );
                    // } else {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       opaque: false,
                    //       pageBuilder: (_, __, ___) => AlbumSearchPage(
                    //         query: value,
                    //         type: 'Artists',
                    //       ),
                    //     ),
                    //   );
                    // }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    if (mediaItem.extras?['album_id'] != null)
                      PopupMenuItem<String>(
                        value: '0',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.album_rounded,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              AppLocalizations.of(context).viewAlbum,
                            ),
                          ],
                        ),
                      ),
                    if (mediaItem.artist != null)
                      ...artists.map(
                        (String artist) => PopupMenuItem<String>(
                          value: artist,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  '${AppLocalizations.of(context).viewArtist} ($artist)',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: titleBoxHeight / 10,
                          ),

                          /// Title container
                          AnimatedText(
                            text: mediaItem.title.split(' (')[0].split('|')[0].trim(),
                            pauseAfterRound: const Duration(seconds: 3),
                            showFadingOnlyWhenScrolling: false,
                            fadingEdgeEndFraction: 0.1,
                            fadingEdgeStartFraction: 0.1,
                            startAfter: const Duration(seconds: 2),
                            style: TextStyle(
                              fontSize: titleBoxHeight / 2.75,
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).accentColor,
                            ),
                          ),

                          SizedBox(
                            height: titleBoxHeight / 40,
                          ),

                          /// Subtitle container
                          AnimatedText(
                            text: '${mediaItem.artist ?? "Unknown"} • ${mediaItem.album ?? "Unknown"}',
                            pauseAfterRound: const Duration(seconds: 3),
                            showFadingOnlyWhenScrolling: false,
                            fadingEdgeEndFraction: 0.1,
                            fadingEdgeStartFraction: 0.1,
                            startAfter: const Duration(seconds: 2),
                            style: TextStyle(
                              fontSize: titleBoxHeight / 6.75,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Seekbar starts from here
              SizedBox(
                height: seekBoxHeight,
                width: width * 0.95,
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data ??
                        PositionData(
                          Duration.zero,
                          Duration.zero,
                          mediaItem.duration ?? Duration.zero,
                        );
                    return SeekBar(
                      // width: width,
                      // height: height,
                      duration: positionData.duration,
                      position: positionData.position,
                      bufferedPosition: positionData.bufferedPosition,
                      offline: offline,
                      onChangeEnd: (newPosition) {
                        audioHandler.seek(newPosition);
                      },
                      audioHandler: audioHandler,
                    );
                  },
                ),
              ),

              /// Final row starts from here
              SizedBox(
                height: controlBoxHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 6.0),
                              StreamBuilder<bool>(
                                stream: audioHandler.playbackState
                                    .map(
                                      (state) => state.shuffleMode == AudioServiceShuffleMode.all,
                                    )
                                    .distinct(),
                                builder: (context, snapshot) {
                                  final shuffleModeEnabled = snapshot.data ?? false;
                                  return IconButton(
                                    icon: shuffleModeEnabled
                                        ? const Icon(
                                            Icons.shuffle_rounded,
                                          )
                                        : Icon(
                                            Icons.shuffle_rounded,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                    tooltip: AppLocalizations.of(context).shuffle,
                                    onPressed: () async {
                                      final enable = !shuffleModeEnabled;
                                      await audioHandler.setShuffleMode(
                                        enable ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
                                      );
                                    },
                                  );
                                },
                              ),
                              if (!offline) LikeButton(mediaItem: mediaItem, size: 25.0),
                            ],
                          ),
                          ControlButtons(
                            audioHandler,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 6.0),
                              StreamBuilder<AudioServiceRepeatMode>(
                                stream:
                                    audioHandler.playbackState.map((state) => state.repeatMode).distinct(),
                                builder: (context, snapshot) {
                                  final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
                                  const texts = ['None', 'All', 'One'];
                                  final icons = [
                                    Icon(
                                      Icons.repeat_rounded,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    const Icon(
                                      Icons.repeat_rounded,
                                    ),
                                    const Icon(
                                      Icons.repeat_one_rounded,
                                    ),
                                  ];
                                  const cycleModes = [
                                    AudioServiceRepeatMode.none,
                                    AudioServiceRepeatMode.all,
                                    AudioServiceRepeatMode.one,
                                  ];
                                  final index = cycleModes.indexOf(repeatMode);
                                  return IconButton(
                                    icon: icons[index],
                                    tooltip: 'Repeat ${texts[(index + 1) % texts.length]}',
                                    onPressed: () async {
                                      // await Hive.box('settings').put(
                                      //   'repeatMode',
                                      //   texts[(index + 1) % texts.length],
                                      // );
                                      await audioHandler.setRepeatMode(
                                        cycleModes[(cycleModes.indexOf(repeatMode) + 1) % cycleModes.length],
                                      );
                                    },
                                  );
                                },
                              ),
                              if (!offline)
                                DownloadButton(
                                  size: 25.0,
                                  data: MediaItemConverter.mediaItemToMap(
                                    mediaItem,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: nowplayingBoxHeight,
              ),
            ],
          ),

          // Up Next with blur background
          SlidingUpPanel(
            minHeight: nowplayingBoxHeight,
            maxHeight: 350,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            boxShadow: const [],
            color: useFullScreenGradient
                ? Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromRGBO(0, 0, 0, 0.05)
                    : const Color.fromRGBO(255, 255, 255, 0.05)
                : Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromRGBO(0, 0, 0, 0.5)
                    : const Color.fromRGBO(255, 255, 255, 0.5),
            // gradientColor![1]!.withOpacity(0.5),
            // useBlurForNowPlaying
            // ? Theme.of(context).brightness == Brightness.dark
            // Colors.black.withOpacity(0.2),
            // : Colors.white.withOpacity(0.7)
            // : Theme.of(context).brightness == Brightness.dark
            // ? Colors.black
            // : Colors.white,
            controller: panelController,
            panelBuilder: (ScrollController scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.center,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ).createShader(
                        Rect.fromLTRB(
                          0,
                          0,
                          rect.width,
                          rect.height,
                        ),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: NowPlayingStream(
                      head: true,
                      headHeight: nowplayingBoxHeight,
                      audioHandler: audioHandler,
                      scrollController: scrollController,
                      panelController: panelController,
                    ),
                  ),
                ),
              );
            },
            header: GestureDetector(
              onTap: () {
                if (panelController.isPanelOpen) {
                  panelController.close();
                } else {
                  if (panelController.panelPosition > 0.9) {
                    panelController.close();
                  } else {
                    panelController.open();
                  }
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (details.delta.dy > 0.0) {
                  panelController.animatePanelToPosition(0.0);
                }
              },
              child: Container(
                height: nowplayingBoxHeight,
                width: width,
                color: Colors.transparent,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).upNext,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialText,
  required TextInputType keyboardType,
  required Function(String) onSubmitted,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctxt) {
      final controller = TextEditingController(text: initialText);
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            TextField(
              autofocus: true,
              controller: controller,
              keyboardType: keyboardType,
              textAlignVertical: TextAlignVertical.bottom,
              onSubmitted: (value) {
                onSubmitted(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.secondary == Colors.white ? Colors.black : Colors.white,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              onSubmitted(controller.text.trim());
            },
            child: Text(
              AppLocalizations.of(context).ok,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      );
    },
  );
}

Future<List<Color>> getColors({
  required ImageProvider imageProvider,
}) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
  final Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
  final Color darkMutedColor = paletteGenerator.darkMutedColor?.color ?? Colors.black;
  final Color lightMutedColor = paletteGenerator.lightMutedColor?.color ?? dominantColor;
  if (dominantColor.computeLuminance() < darkMutedColor.computeLuminance()) {
    // checks if the luminance of the darkMuted color is > than the luminance of the dominant
    // GetIt.I<MyTheme>().playGradientColor = [
    //   darkMutedColor,
    //   dominantColor,
    // ];
    return [
      darkMutedColor,
      dominantColor,
    ];
  } else if (dominantColor == darkMutedColor) {
    // if the two colors are the same, it will replace dominantColor by lightMutedColor
    // GetIt.I<MyTheme>().playGradientColor = [
    //   lightMutedColor,
    //   darkMutedColor,
    // ];
    return [
      lightMutedColor,
      darkMutedColor,
    ];
  } else {
    // GetIt.I<MyTheme>().playGradientColor = [
    //   dominantColor,
    //   darkMutedColor,
    // ];
    return [
      dominantColor,
      darkMutedColor,
    ];
  }
}

// ignore: avoid_classes_with_only_static_members
class MediaItemConverter {
  static Map mediaItemToMap(MediaItem mediaItem) {
    return {
      'id': mediaItem.id,
      'album': mediaItem.album.toString(),
      'album_id': mediaItem.extras?['album_id'],
      'artist': mediaItem.artist.toString(),
      'duration': mediaItem.duration?.inSeconds.toString(),
      'genre': mediaItem.genre.toString(),
      'has_lyrics': mediaItem.extras!['has_lyrics'],
      'image': mediaItem.artUri.toString(),
      'language': mediaItem.extras?['language'].toString(),
      'release_date': mediaItem.extras?['release_date'],
      'subtitle': mediaItem.extras?['subtitle'],
      'title': mediaItem.title,
      'url': mediaItem.extras!['url'].toString(),
      'lowUrl': mediaItem.extras!['lowUrl']?.toString(),
      'highUrl': mediaItem.extras!['highUrl']?.toString(),
      'year': mediaItem.extras?['year'].toString(),
      '320kbps': mediaItem.extras?['320kbps'],
      'quality': mediaItem.extras?['quality'],
      'perma_url': mediaItem.extras?['perma_url'],
      'expire_at': mediaItem.extras?['expire_at'],
    };
  }

  static MediaItem mapToMediaItem(
    Map song, {
    bool addedByAutoplay = false,
    bool autoplay = true,
  }) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null || song['duration'] == 'null') ? '180' : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.parse(
        song['image'].toString().replaceAll('50x50', '500x500').replaceAll('150x150', '500x500'),
      ),
      genre: song['language'].toString(),
      extras: {
        'url': song['url'],
        'lowUrl': song['lowUrl'],
        'highUrl': song['highUrl'],
        'year': song['year'],
        'language': song['language'],
        '320kbps': song['320kbps'],
        'quality': song['quality'],
        'has_lyrics': song['has_lyrics'],
        'release_date': song['release_date'],
        'album_id': song['album_id'],
        'subtitle': song['subtitle'],
        'perma_url': song['perma_url'],
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'expire_at': song['expire_at'],
      },
    );
  }

  static MediaItem downMapToMediaItem(Map song) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null || song['duration'] == 'null') ? '180' : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.file(song['image'].toString()),
      genre: song['genre'].toString(),
      extras: {
        'url': song['path'].toString(),
        'year': song['year'],
        'language': song['genre'],
        'release_date': song['release_date'],
        'album_id': song['album_id'],
        'subtitle': song['subtitle'],
        'quality': song['quality'],
      },
    );
  }
}

class PopupDialog {
  void showPopup({
    required BuildContext context,
    required Widget child,
    double radius = 20.0,
    Color? backColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.transparent,
          content: Stack(
            children: [
              GestureDetector(onTap: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  clipBehavior: Clip.antiAlias,
                  color: backColor,
                  child: child,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Card(
                  elevation: 15.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GradientCard extends StatefulWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.radius,
    this.elevation,
  });
  final Widget child;
  final BorderRadius? radius;
  final double? elevation;
  @override
  _GradientCardState createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation ?? 3,
      shape: RoundedRectangleBorder(
        borderRadius: widget.radius ?? BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Colors.white,
                    Theme.of(context).canvasColor,
                  ]
                : [
                    Colors.white,
                    Theme.of(context).canvasColor,
                  ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class AddToPlaylist {
  // Box settingsBox = Hive.box('settings');
  List playlistNames = ['Favorite Songs'];
  Map playlistDetails = {};

  void addToPlaylist(BuildContext context, MediaItem? mediaItem) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return BottomGradientContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context).createPlaylist),
                  leading: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: SizedBox.square(
                      dimension: 50,
                      child: Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showTextInputDialog(
                      context: context,
                      keyboardType: TextInputType.name,
                      title: AppLocalizations.of(context).createNewPlaylist,
                      onSubmitted: (String value) async {
                        final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
                        value.replaceAll(avoid, '').replaceAll('  ', ' ');
                        if (value.trim() == '') {
                          value = 'Playlist ${playlistNames.length}';
                        }
                        // if (playlistNames.contains(value) || await Hive.boxExists(value)) {
                        //   value = '$value (1)';
                        // }
                        playlistNames.add(value);
                        // settingsBox.put('playlistNames', playlistNames);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                if (playlistNames.isEmpty)
                  const SizedBox()
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: playlistNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: playlistDetails[playlistNames[index]] == null ||
                                playlistDetails[playlistNames[index]]['imagesList'] == null
                            ? Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: const SizedBox.square(
                                  dimension: 50,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/album.png',
                                    ),
                                  ),
                                ),
                              )
                            : Collage(
                                imageList: playlistDetails[playlistNames[index]]['imagesList'] as List,
                                showGrid: true,
                                placeholderImage: 'assets/cover.jpg',
                              ),
                        title: Text(
                          '${playlistDetails.containsKey(playlistNames[index]) ? playlistDetails[playlistNames[index]]["name"] ?? playlistNames[index] : playlistNames[index]}',
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          if (mediaItem != null) {
                            addItemToPlaylist(
                              playlistNames[index].toString(),
                              mediaItem,
                            );
                            // ShowSnackBar().showSnackBar(
                            //   context,
                            //   '${AppLocalizations.of(context).addedTo} ${playlistDetails.containsKey(playlistNames[index]) ? playlistDetails[playlistNames[index]]["name"] ?? playlistNames[index] : playlistNames[index]}',
                            // );
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    super.key,
    required this.text,
    this.style,
    this.textScaleFactor,
    this.textDirection = TextDirection.ltr,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.defaultAlignment = TextAlign.center,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.showFadingOnlyWhenScrolling = true,
    this.fadingEdgeStartFraction = 0.0,
    this.fadingEdgeEndFraction = 0.0,
    this.numberOfRounds,
    this.startPadding = 0.0,
    this.accelerationDuration = Duration.zero,
    this.accelerationCurve = Curves.decelerate,
    this.decelerationDuration = Duration.zero,
    this.decelerationCurve = Curves.decelerate,
    this.onDone,
  });
  final String text;
  final TextStyle? style;
  final double? textScaleFactor;
  final TextDirection textDirection;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign defaultAlignment;
  final double blankSpace;
  final double velocity;
  final Duration startAfter;
  final Duration pauseAfterRound;
  final int? numberOfRounds;
  final bool showFadingOnlyWhenScrolling;
  final double fadingEdgeStartFraction;
  final double fadingEdgeEndFraction;
  final double startPadding;
  final Duration accelerationDuration;
  final Curve accelerationCurve;
  final Duration decelerationDuration;
  final Curve decelerationCurve;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: text,
          style: style,
        );

        final tp = TextPainter(
          maxLines: 1,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        );

        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return SizedBox(
            height: tp.height,
            width: constraints.maxWidth,
            child: Marquee(
              text: '  $text${" " * 30}',
              style: style,
              textScaleFactor: textScaleFactor,
              textDirection: textDirection,
              scrollAxis: scrollAxis,
              crossAxisAlignment: crossAxisAlignment,
              blankSpace: blankSpace,
              velocity: velocity,
              startAfter: startAfter,
              pauseAfterRound: pauseAfterRound,
              numberOfRounds: numberOfRounds,
              showFadingOnlyWhenScrolling: showFadingOnlyWhenScrolling,
              fadingEdgeStartFraction: fadingEdgeStartFraction,
              fadingEdgeEndFraction: fadingEdgeEndFraction,
              startPadding: startPadding,
              accelerationDuration: accelerationDuration,
              accelerationCurve: accelerationCurve,
              decelerationDuration: decelerationDuration,
              decelerationCurve: decelerationCurve,
              onDone: onDone,
            ),
          );
        } else {
          return SizedBox(
            width: constraints.maxWidth,
            child: Text(
              text,
              style: style,
              textAlign: defaultAlignment,
            ),
          );
        }
      },
    );
  }
}

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    super.key,
    required this.data,
    this.icon,
    this.size,
  });
  final Map data;
  final String? icon;
  final double? size;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  late Download down;
  // final Box downloadsBox = Hive.box('downloads');
  final ValueNotifier<bool> showStopButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    down = Download(widget.data['id'].toString());
    down.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const isDownloaded = false;

    return SizedBox.square(
      dimension: 50,
      child: Center(
        child: isDownloaded
            // child: (downloadsBox.containsKey(widget.data['id']))
            ? IconButton(
                icon: const Icon(Icons.download_done_rounded),
                tooltip: 'Download Done',
                color: Theme.of(context).colorScheme.secondary,
                iconSize: widget.size ?? 24.0,
                onPressed: () {
                  down.prepareDownload(context, widget.data);
                },
              )
            : down.progress == 0
                ? IconButton(
                    icon: Icon(
                      widget.icon == 'download' ? Icons.download_rounded : Icons.save_alt,
                    ),
                    iconSize: widget.size ?? 24.0,
                    color: Theme.of(context).iconTheme.color,
                    tooltip: 'Download',
                    onPressed: () {
                      down.prepareDownload(context, widget.data);
                    },
                  )
                : GestureDetector(
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: showStopButton,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                                iconSize: 25.0,
                                color: Theme.of(context).iconTheme.color,
                                tooltip: AppLocalizations.of(
                                  context,
                                ).stopDown,
                                onPressed: () {
                                  down.download = false;
                                },
                              ),
                            ),
                            builder: (
                              BuildContext context,
                              bool showValue,
                              Widget? child,
                            ) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: !showValue,
                                      child: Center(
                                        child: Text(
                                          down.progress == null ? '0%' : '${(100 * down.progress!).round()}%',
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: showValue,
                                      child: child!,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showStopButton.value = true;
                      Future.delayed(const Duration(seconds: 2), () async {
                        showStopButton.value = false;
                      });
                    },
                  ),
      ),
    );
  }
}

class MultiDownloadButton extends StatefulWidget {
  const MultiDownloadButton({
    super.key,
    required this.data,
    required this.playlistName,
  });
  final List data;
  final String playlistName;

  @override
  _MultiDownloadButtonState createState() => _MultiDownloadButtonState();
}

class _MultiDownloadButtonState extends State<MultiDownloadButton> {
  late Download down;
  int done = 0;

  @override
  void initState() {
    super.initState();
    down = Download(widget.data.first['id'].toString());
    down.addListener(() {
      setState(() {});
    });
  }

  Future<void> _waitUntilDone(String id) async {
    while (down.lastDownloadId != id) {
      await Future.delayed(const Duration(seconds: 1));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: (down.lastDownloadId == widget.data.last['id'])
            ? IconButton(
                icon: const Icon(
                  Icons.download_done_rounded,
                ),
                color: Theme.of(context).colorScheme.secondary,
                iconSize: 25.0,
                tooltip: AppLocalizations.of(context).downDone,
                onPressed: () {},
              )
            : down.progress == 0
                ? Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.download_rounded,
                      ),
                      iconSize: 25.0,
                      tooltip: AppLocalizations.of(context).down,
                      onPressed: () async {
                        for (final items in widget.data) {
                          down.prepareDownload(
                            context,
                            items as Map,
                            createFolder: true,
                            folderName: widget.playlistName,
                          );
                          await _waitUntilDone(items['id'].toString());
                          setState(() {
                            done++;
                          });
                        }
                      },
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Text(
                          down.progress == null ? '0%' : '${(100 * down.progress!).round()}%',
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: CircularProgressIndicator(
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            value: done / widget.data.length,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class AlbumDownloadButton extends StatefulWidget {
  const AlbumDownloadButton({
    super.key,
    required this.albumId,
    required this.albumName,
  });
  final String albumId;
  final String albumName;

  @override
  _AlbumDownloadButtonState createState() => _AlbumDownloadButtonState();
}

class _AlbumDownloadButtonState extends State<AlbumDownloadButton> {
  late Download down;
  int done = 0;
  List data = [];
  bool finished = false;

  @override
  void initState() {
    super.initState();
    down = Download(widget.albumId);
    down.addListener(() {
      setState(() {});
    });
  }

  Future<void> _waitUntilDone(String id) async {
    while (down.lastDownloadId != id) {
      await Future.delayed(const Duration(seconds: 1));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: finished
            ? IconButton(
                icon: const Icon(
                  Icons.download_done_rounded,
                ),
                color: Theme.of(context).colorScheme.secondary,
                iconSize: 25.0,
                tooltip: AppLocalizations.of(context).downDone,
                onPressed: () {},
              )
            : down.progress == 0
                ? Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.download_rounded,
                      ),
                      iconSize: 25.0,
                      color: Theme.of(context).iconTheme.color,
                      tooltip: AppLocalizations.of(context).down,
                      onPressed: () async {
                        // ShowSnackBar().showSnackBar(
                        //   context,
                        //   '${AppLocalizations.of(context).downingAlbum} "${widget.albumName}"',
                        // );

                        // data = (await SaavnAPI().fetchAlbumSongs(widget.albumId))['songs'] as List;
                        // for (final items in data) {
                        //   down.prepareDownload(
                        //     context,
                        //     items as Map,
                        //     createFolder: true,
                        //     folderName: widget.albumName,
                        //   );
                        //   await _waitUntilDone(items['id'].toString());
                        //   setState(() {
                        //     done++;
                        //   });
                        // }
                        // finished = true;
                      },
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Text(
                          down.progress == null ? '0%' : '${(100 * down.progress!).round()}%',
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: CircularProgressIndicator(
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            value: data.isEmpty ? 0 : done / data.length,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class BottomGradientContainer extends StatefulWidget {
  const BottomGradientContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
  });
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  @override
  _BottomGradientContainerState createState() => _BottomGradientContainerState();
}

class _BottomGradientContainerState extends State<BottomGradientContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(25, 0, 25, 25),
      padding: widget.padding ?? const EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  Colors.white,
                  Theme.of(context).canvasColor,
                ]
              : [
                  Colors.white,
                  Theme.of(context).canvasColor,
                ],
        ),
      ),
      child: widget.child,
    );
  }
}

class Download with ChangeNotifier {
  factory Download(String id) {
    if (_instances.containsKey(id)) {
      return _instances[id]!;
    } else {
      final instance = Download._internal(id);
      _instances[id] = instance;
      return instance;
    }
  }

  Download._internal(this.id);
  static final Map<String, Download> _instances = {};
  final String id;

  int? rememberOption;
  final ValueNotifier<bool> remember = ValueNotifier<bool>(false);
  String preferredDownloadQuality = '320 kbps';
  String preferredYtDownloadQuality = 'High';
  String downloadFormat = 'm4a';
  bool createDownloadFolder = false;
  bool createYoutubeFolder = false;
  double? progress = 0.0;
  String lastDownloadId = '';
  bool downloadLyrics = false;
  bool download = true;

  Future<void> prepareDownload(
    BuildContext context,
    Map data, {
    bool createFolder = false,
    String? folderName,
  }) async {
    download = true;
    if (!Platform.isWindows) {
      PermissionStatus status = await Permission.storage.status;
      if (status.isDenied) {
        await [
          Permission.storage,
          Permission.accessMediaLocation,
          Permission.mediaLibrary,
        ].request();
      }
      status = await Permission.storage.status;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    data['title'] = data['title'].toString().split('(From')[0].trim();

    String filename = '';
    const int downFilename = 0;
    if (downFilename == 0) {
      filename = '${data["title"]} - ${data["artist"]}';
    } else if (downFilename == 1) {
      filename = '${data["artist"]} - ${data["title"]}';
    } else {
      filename = '${data["title"]}';
    }
    // String filename = '${data["title"]} - ${data["artist"]}';
    String dlPath = '';
    if (filename.length > 200) {
      final String temp = filename.substring(0, 200);
      final List tempList = temp.split(', ');
      tempList.removeLast();
      filename = tempList.join(', ');
    }

    filename = '${filename.replaceAll(avoid, "").replaceAll("  ", " ")}.m4a';
    if (dlPath == '') {
      final String? temp = await ExtStorageProvider.getExtStorage(dirName: 'Music');
      dlPath = temp!;
    }
    if (data['url'].toString().contains('google') && createYoutubeFolder) {
      dlPath = '$dlPath/YouTube';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    if (createFolder && createDownloadFolder && folderName != null) {
      final String foldername = folderName.replaceAll(avoid, '');
      dlPath = '$dlPath/$foldername';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    final bool exists = await File('$dlPath/$filename').exists();
    if (exists) {
      if (remember.value == true && rememberOption != null) {
        switch (rememberOption) {
          case 0:
            lastDownloadId = data['id'].toString();
            break;
          case 1:
            downloadSong(context, dlPath, filename, data);
            break;
          case 2:
            while (await File('$dlPath/$filename').exists()) {
              filename = filename.replaceAll('.m4a', ' (1).m4a');
            }
            break;
          default:
            lastDownloadId = data['id'].toString();
            break;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                AppLocalizations.of(context).alreadyExists,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '"${data['title']}" ${AppLocalizations.of(context).downAgain}',
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              actions: [
                Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: remember,
                      builder: (
                        BuildContext context,
                        bool rememberValue,
                        Widget? child,
                      ) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Theme.of(context).colorScheme.secondary,
                                value: rememberValue,
                                onChanged: (bool? value) {
                                  remember.value = value ?? false;
                                },
                              ),
                              Text(
                                AppLocalizations.of(context).rememberChoice,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            onPressed: () {
                              lastDownloadId = data['id'].toString();
                              Navigator.pop(context);
                              rememberOption = 0;
                            },
                            child: Text(
                              AppLocalizations.of(context).no,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              // Hive.box('downloads').delete(data['id']);
                              downloadSong(context, dlPath, filename, data);
                              rememberOption = 1;
                            },
                            child: Text(AppLocalizations.of(context).yesReplace),
                          ),
                          const SizedBox(width: 5.0),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              while (await File('$dlPath/$filename').exists()) {
                                filename = filename.replaceAll('.m4a', ' (1).m4a');
                              }
                              rememberOption = 2;
                              downloadSong(context, dlPath, filename, data);
                            },
                            child: Text(
                              AppLocalizations.of(context).yes,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary == Colors.white
                                    ? Colors.black
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    } else {
      downloadSong(context, dlPath, filename, data);
    }
  }

  Future<void> downloadSong(
    BuildContext context,
    String? dlPath,
    String fileName,
    Map data,
  ) async {
    progress = null;
    notifyListeners();
    String? filepath;
    late String filepath2;
    String? appPath;
    final List<int> bytes = [];
    String lyrics;
    final artname = fileName.replaceAll('.m4a', '.jpg');
    if (!Platform.isWindows) {
      // appPath = Hive.box('settings').get('tempDirPath')?.toString();
      appPath = null;
      appPath ??= (await getTemporaryDirectory()).path;
    } else {
      final Directory? temp = await getDownloadsDirectory();
      appPath = temp!.path;
    }

    try {
      await File('$dlPath/$fileName').create(recursive: true).then((value) => filepath = value.path);
      // print('created audio file');

      await File('$appPath/$artname').create(recursive: true).then((value) => filepath2 = value.path);
    } catch (e) {
      await [
        Permission.manageExternalStorage,
      ].request();
      await File('$dlPath/$fileName').create(recursive: true).then((value) => filepath = value.path);
      // print('created audio file');
      await File('$appPath/$artname').create(recursive: true).then((value) => filepath2 = value.path);
    }
    // debugPrint('Audio path $filepath');
    // debugPrint('Image path $filepath2');
    String kUrl = data['url'].toString();

    if (data['url'].toString().contains('google')) {
      // filename = filename.replaceAll('.m4a', '.opus');

      kUrl = preferredYtDownloadQuality == 'High' ? data['highUrl'].toString() : data['lowUrl'].toString();
      if (kUrl == 'null') {
        kUrl = data['url'].toString();
      }
      // log("low quality is ${data['lowUrl']}");
      // log("high quality is ${data['highUrl']}");
    } else {
      kUrl = kUrl.replaceAll(
        '_96.',
        "_${preferredDownloadQuality.replaceAll(' kbps', '')}.",
      );
    }

    final client = Client();
    final response = await client.send(Request('GET', Uri.parse(kUrl)));
    final int total = response.contentLength ?? 0;
    int recieved = 0;
    response.stream.asBroadcastStream();
    response.stream.listen((value) {
      bytes.addAll(value);
      try {
        recieved += value.length;
        // log('received ${value.length ~/ 1024} kbs, total = ${total ~/ 1024}kb, received ${recieved ~/ 1024}kb');
        progress = recieved / total;
        notifyListeners();
        if (!download) {
          client.close();
        }
      } catch (e) {
        Logger.root.severe('Error in download: $e');
        // print('Error: $e');
      }
    }).onDone(() async {
      if (download) {
        final file = File(filepath!);
        await file.writeAsBytes(bytes);

        final client = HttpClient();
        final HttpClientRequest request2 = await client.getUrl(Uri.parse(data['image'].toString()));
        final HttpClientResponse response2 = await request2.close();
        final bytes2 = await consolidateHttpClientResponseBytes(response2);
        final File file2 = File(filepath2);

        await file2.writeAsBytes(bytes2);
        try {
          lyrics = downloadLyrics
              ? await Lyrics.getLyrics(
                  id: data['id'].toString(),
                  title: data['title'].toString(),
                  artist: data['artist'].toString(),
                  saavnHas: data['has_lyrics'] == 'true',
                )
              : '';
        } catch (e) {
          Logger.root.severe('Error fetching lyrics: $e');
          // log('Error fetching lyrics: $e');
          lyrics = '';
        }
        // commented out not to use FFmpeg as it increases the size of the app
        // can uncomment this if you want to use FFmpeg to convert the audio format
        // to any desired codec instead of the default m4a one.

        // final List<String> availableFormats = ['m4a'];
        // if (downloadFormat != 'm4a' &&
        //     availableFormats.contains(downloadFormat)) {
        //   List<String>? argsList;
        //   if (downloadFormat == 'mp3') {
        //     argsList = [
        //       '-y',
        //       '-i',
        //       '$filepath',
        //       '-c:a',
        //       'libmp3lame',
        //       '-b:a',
        //       '320k',
        //       (filepath!.replaceAll('.m4a', '.mp3'))
        //     ];
        //   }
        //   if (downloadFormat == 'm4a') {
        //     argsList = [
        //       '-y',
        //       '-i',
        //       filepath!,
        //       '-c:a',
        //       'aac',
        //       '-b:a',
        //       '320k',
        //       filepath!.replaceAll('.m4a', '.m4a')
        //     ];
        //   }
        //   // await FlutterFFmpeg().executeWithArguments(_argsList);
        //   // await File(filepath!).delete();
        //   // filepath = filepath!.replaceAll('.m4a', '.$downloadFormat');
        // }

        // debugPrint('Started tag editing');
        final Tag tag = Tag(
          title: data['title'].toString(),
          artist: data['artist'].toString(),
          albumArtist: data['album_artist']?.toString() ?? data['artist']?.toString().split(', ')[0],
          artwork: filepath2,
          album: data['album'].toString(),
          genre: data['language'].toString(),
          year: data['year'].toString(),
          lyrics: lyrics,
          comment: 'BlackHole',
        );
        if (Platform.isAndroid) {
          try {
            final tagger = Audiotagger();
            await tagger.writeTags(
              path: filepath!,
              tag: tag,
            );
            // await Future.delayed(const Duration(seconds: 1), () async {
            //   if (await file2.exists()) {
            //     await file2.delete();
            //   }
            // });
          } catch (e) {
            Logger.root.severe('Error editing tags: $e');
          }
        }
        client.close();
        // debugPrint('Done');
        lastDownloadId = data['id'].toString();
        progress = 0.0;
        notifyListeners();

        final songData = {
          'id': data['id'].toString(),
          'title': data['title'].toString(),
          'subtitle': data['subtitle'].toString(),
          'artist': data['artist'].toString(),
          'albumArtist': data['album_artist']?.toString() ?? data['artist']?.toString().split(', ')[0],
          'album': data['album'].toString(),
          'genre': data['language'].toString(),
          'year': data['year'].toString(),
          'lyrics': lyrics,
          'duration': data['duration'],
          'release_date': data['release_date'].toString(),
          'album_id': data['album_id'].toString(),
          'perma_url': data['perma_url'].toString(),
          'quality': preferredDownloadQuality,
          'path': filepath,
          'image': filepath2,
          'image_url': data['image'].toString(),
          'from_yt': data['language'].toString() == 'YouTube',
          'dateAdded': DateTime.now().toString(),
        };
        // Hive.box('downloads').put(songData['id'].toString(), songData);

        // ShowSnackBar().showSnackBar(
        //   context,
        //   '"${data['title']}" ${AppLocalizations.of(context)!.downed}',
        // );
      } else {
        download = true;
        progress = 0.0;
        File(filepath!).delete();
        File(filepath2).delete();
      }
    });
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.mediaItem,
    this.size,
    this.data,
    this.showSnack = false,
  });
  final MediaItem? mediaItem;
  final double? size;
  final Map? data;
  final bool showSnack;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.mediaItem != null) {
        liked = checkPlaylist('Favorite Songs', widget.mediaItem!.id);
      } else {
        liked = checkPlaylist('Favorite Songs', widget.data!['id'].toString());
      }
    } catch (e) {
      Logger.root.severe('Error in likeButton: $e');
    }
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        icon: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? Colors.redAccent : Theme.of(context).iconTheme.color,
        ),
        iconSize: widget.size ?? 24.0,
        tooltip: liked ? AppLocalizations.of(context).unlike : AppLocalizations.of(context).like,
        onPressed: () async {
          liked
              ? removeLiked(
                  widget.mediaItem == null ? widget.data!['id'].toString() : widget.mediaItem!.id,
                )
              : widget.mediaItem == null
                  ? addMapToPlaylist('Favorite Songs', widget.data!)
                  : addItemToPlaylist('Favorite Songs', widget.mediaItem!);

          if (!liked) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          setState(() {
            liked = !liked;
          });
          // if (widget.showSnack) {
          //   ShowSnackBar().showSnackBar(
          //     context,
          //     liked ? AppLocalizations.of(context).addedToFav : AppLocalizations.of(context).removedFromFav,
          //     action: SnackBarAction(
          //       textColor: Theme.of(context).colorScheme.secondary,
          //       label: AppLocalizations.of(context).undo,
          //       onPressed: () {
          //         liked
          //             ? removeLiked(
          //                 widget.mediaItem == null ? widget.data!['id'].toString() : widget.mediaItem!.id,
          //               )
          //             : widget.mediaItem == null
          //                 ? addMapToPlaylist('Favorite Songs', widget.data!)
          //                 : addItemToPlaylist(
          //                     'Favorite Songs',
          //                     widget.mediaItem!,
          //                   );

          //         liked = !liked;
          //         setState(() {});
          //       },
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}

// ignore: avoid_classes_with_only_static_members
class Lyrics {
  static Future<String> getLyrics({
    required String id,
    required String title,
    required String artist,
    required bool saavnHas,
  }) async {
    String lyrics = '';
    if (saavnHas) {
      lyrics = await getSaavnLyrics(id);
    } else {
      lyrics = await getMusixMatchLyrics(title: title, artist: artist);
      if (lyrics == '') {
        lyrics = await getGoogleLyrics(title: title, artist: artist);
      }
    }
    return lyrics;
  }

  static Future<String> getSaavnLyrics(String id) async {
    final Uri lyricsUrl = Uri.https(
      'www.jiosaavn.com',
      '/api.php?__call=lyrics.getLyrics&lyrics_id=$id&ctx=web6dot0&api_version=4&_format=json',
    );
    final Response res = await get(lyricsUrl, headers: {'Accept': 'application/json'});

    final List<String> rawLyrics = res.body.split('-->');
    final fetchedLyrics = json.decode(rawLyrics[1]);
    final String lyrics = fetchedLyrics['lyrics'].toString().replaceAll('<br>', '\n');
    return lyrics;
  }

  static Future<String> getGoogleLyrics({
    required String title,
    required String artist,
  }) async {
    const String url = 'https://www.google.com/search?client=safari&rls=en&ie=UTF-8&oe=UTF-8&q=';
    const String delimiter1 =
        '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
    const String delimiter2 =
        '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';
    String lyrics = '';
    try {
      lyrics = (await get(
        Uri.parse(Uri.encodeFull('$url$title by $artist lyrics')),
      ))
          .body;
      lyrics = lyrics.split(delimiter1).last;
      lyrics = lyrics.split(delimiter2).first;
      if (lyrics.contains('<meta charset="UTF-8">')) {
        throw Error();
      }
    } catch (_) {
      try {
        lyrics = (await get(
          Uri.parse(
            Uri.encodeFull('$url$title by $artist song lyrics'),
          ),
        ))
            .body;
        lyrics = lyrics.split(delimiter1).last;
        lyrics = lyrics.split(delimiter2).first;
        if (lyrics.contains('<meta charset="UTF-8">')) {
          throw Error();
        }
      } catch (_) {
        try {
          lyrics = (await get(
            Uri.parse(
              Uri.encodeFull(
                '$url${title.split("-").first} by $artist lyrics',
              ),
            ),
          ))
              .body;
          lyrics = lyrics.split(delimiter1).last;
          lyrics = lyrics.split(delimiter2).first;
          if (lyrics.contains('<meta charset="UTF-8">')) {
            throw Error();
          }
        } catch (_) {
          lyrics = '';
        }
      }
    }
    return lyrics.trim();
  }

  static Future<String> getOffLyrics(String path) async {
    try {
      final Audiotagger tagger = Audiotagger();
      final Tag? tags = await tagger.readTags(path: path);
      return tags?.lyrics ?? '';
    } catch (e) {
      return '';
    }
  }

  static Future<String> getLyricsLink(String song, String artist) async {
    const String authority = 'www.musixmatch.com';
    final String unencodedPath = '/search/$song $artist';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) {
      return '';
    }
    final RegExpMatch? result = RegExp(r'href=\"(\/lyrics\/.*?)\"').firstMatch(res.body);
    return result == null ? '' : result[1]!;
  }

  static Future<String> scrapLink(String unencodedPath) async {
    const String authority = 'www.musixmatch.com';
    final Response res = await get(Uri.https(authority, unencodedPath));
    if (res.statusCode != 200) {
      return '';
    }
    final List<String?> lyrics = RegExp(
      r'<span class=\"lyrics__content__ok\">(.*?)<\/span>',
      dotAll: true,
    ).allMatches(res.body).map((m) => m[1]).toList();

    return lyrics.isEmpty ? '' : lyrics.join('\n');
  }

  static Future<String> getMusixMatchLyrics({
    required String title,
    required String artist,
  }) async {
    final String link = await getLyricsLink(title, artist);
    final String lyrics = await scrapLink(link);
    return lyrics;
  }
}

Widget emptyScreen(
  BuildContext context,
  int turns,
  String text1,
  double size1,
  String text2,
  double size2,
  String text3,
  double size3, {
  bool useWhite = false,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: turns,
            child: Text(
              text1,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: size1,
                color: useWhite ? Colors.white : Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                text2,
                style: TextStyle(
                  fontSize: size2,
                  color: useWhite ? Colors.white : Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                text3,
                style: TextStyle(
                  fontSize: size3,
                  fontWeight: FontWeight.w600,
                  color: useWhite ? Colors.white : null,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class SeekBar extends StatefulWidget {
  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.offline,
    required this.audioHandler,
    // required this.width,
    // required this.height,
    this.bufferedPosition = Duration.zero,
    this.onChanged,
    this.onChangeEnd,
  });
  final AudioPlayerHandler audioHandler;
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final bool offline;
  // final double width;
  // final double height;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = min(
      _dragValue ?? widget.position.inMilliseconds.toDouble(),
      widget.duration.inMilliseconds.toDouble(),
    );
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Theme.of(context).iconTheme.color!.withOpacity(0.5),
            inactiveTrackColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            // trackShape: RoundedRectSliderTrackShape(),
            trackShape: const RectangularSliderTrackShape(),
          ),
          child: ExcludeSemantics(
            child: Slider(
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                widget.bufferedPosition.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble(),
              ),
              onChanged: (value) {},
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
            activeTrackColor: Theme.of(context).iconTheme.color,
            thumbColor: Theme.of(context).iconTheme.color,
          ),
          child: Slider(
            max: widget.duration.inMilliseconds.toDouble(),
            value: value,
            onChanged: (value) {
              if (!_dragging) {
                _dragging = true;
              }
              setState(() {
                _dragValue = value;
              });
              widget.onChanged?.call(Duration(milliseconds: value.round()));
            },
            onChangeEnd: (value) {
              widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
              _dragging = false;
            },
          ),
        ),
        // if (widget.offline)
        //   Positioned(
        //     left: 22.0,
        //     bottom: 45.0,
        //     child: Icon(
        //       Icons.wifi_off_rounded,
        //       color: Theme.of(context).disabledColor,
        //       size: 15.0,
        //     ),
        //   ),
        Positioned(
          right: 25.0,
          top: 10,
          child: StreamBuilder<double>(
            stream: widget.audioHandler.speed,
            builder: (context, snapshot) {
              final String speedValue = '${snapshot.data?.toStringAsFixed(1) ?? 1.0}x';
              return GestureDetector(
                child: Text(
                  speedValue,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: speedValue == '1.0x' ? Theme.of(context).disabledColor : null,
                  ),
                ),
                onTap: () {
                  showSliderDialog(
                    context: context,
                    title: AppLocalizations.of(context).adjustSpeed,
                    divisions: 25,
                    min: 0.5,
                    max: 3.0,
                    audioHandler: widget.audioHandler,
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          left: 25.0,
          bottom: 10,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$_position')?.group(1) ?? '$_position',
          ),
        ),
        Positioned(
          right: 25.0,
          bottom: 10,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$_duration')?.group(1) ?? '$_duration',
            // style: Theme.of(context).textTheme.caption!.copyWith(
            //       color: Theme.of(context).iconTheme.color,
            //     ),
          ),
        ),
      ],
    );
  }

  Duration get _duration => widget.duration;
  Duration get _position => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  required AudioPlayerHandler audioHandler,
  String valueSuffix = '',
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: audioHandler.speed,
        builder: (context, snapshot) {
          double value = snapshot.data ?? audioHandler.speed.value;
          if (value > max) {
            value = max;
          }
          if (value < min) {
            value = min;
          }
          return SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.minus),
                      onPressed: audioHandler.speed.value > min
                          ? () {
                              audioHandler.setSpeed(audioHandler.speed.value - 0.1);
                            }
                          : null,
                    ),
                    Text(
                      '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                      style: const TextStyle(
                        fontFamily: 'Fixed',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.plus),
                      onPressed: audioHandler.speed.value < max
                          ? () {
                              audioHandler.setSpeed(audioHandler.speed.value + 0.1);
                            }
                          : null,
                    ),
                  ],
                ),
                Slider(
                  inactiveColor: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                  activeColor: Theme.of(context).iconTheme.color,
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: value,
                  onChanged: audioHandler.setSpeed,
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

void copyToClipboard({
  required BuildContext context,
  required String text,
  String? displayText,
}) {
  Clipboard.setData(
    ClipboardData(text: text),
  );
  // ShowSnackBar().showSnackBar(
  //   context,
  //   displayText ?? AppLocalizations.of(context).copied,
  // );
}
