import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioPlayerImage extends StatelessWidget {
  const AudioPlayerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.square(
          dimension: constraints.maxWidth * 0.75,
          child: SafeImage(
            url: 'https://picsum.photos/200',
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }
}
