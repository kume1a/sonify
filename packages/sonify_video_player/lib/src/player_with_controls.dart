import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../sonify_video_player.dart';
import 'notifiers/index.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SonifyVideoPlayerController controller = SonifyVideoPlayerController.of(context);

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: calculateAspectRatio(context),
          child: buildPlayerWithControls(controller, context),
        ),
      ),
    );
  }

  Widget buildControls(
    BuildContext context,
    SonifyVideoPlayerController controller,
  ) {
    if (!controller.showOptions) {
      return const SizedBox.shrink();
    }

    return controller.customControls ?? const VideoControls();
  }

  double calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }

  Widget buildPlayerWithControls(
    SonifyVideoPlayerController controller,
    BuildContext context,
  ) {
    return Stack(
      children: <Widget>[
        if (controller.placeholder != null) controller.placeholder!,
        InteractiveViewer(
          transformationController: controller.transformationController,
          maxScale: controller.maxScale,
          panEnabled: controller.zoomAndPan,
          scaleEnabled: controller.zoomAndPan,
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.aspectRatio ?? controller.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(controller.videoPlayerController),
            ),
          ),
        ),
        if (controller.overlay != null) controller.overlay!,
        if (Theme.of(context).platform != TargetPlatform.iOS)
          Consumer<PlayerNotifier>(
            builder: (
              BuildContext context,
              PlayerNotifier notifier,
              Widget? widget,
            ) =>
                Visibility(
              visible: !notifier.hideStuff,
              child: AnimatedOpacity(
                opacity: notifier.hideStuff ? 0.0 : 0.8,
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black54),
                  child: SizedBox.expand(),
                ),
              ),
            ),
          ),
        if (!controller.isFullScreen)
          buildControls(context, controller)
        else
          SafeArea(
            bottom: false,
            child: buildControls(context, controller),
          ),
      ],
    );
  }
}
