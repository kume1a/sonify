import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

/// Marquee text along Axis.horizontal for the purpose of the demo.
class OptionalMarquee extends StatelessWidget {
  const OptionalMarquee({
    super.key,
    required this.text,
    this.height = 30,
    this.blankSpace = 40,
    this.style,
  });

  final String text;
  final double height;
  final double blankSpace;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final willTextOverflow = _willTextOverflow(
          text: text,
          style: style,
          maxWidth: constraints.maxWidth,
        );

        if (willTextOverflow) {
          return SizedBox(
            height: height,
            width: constraints.maxWidth,
            child: Center(
              child: Marquee(
                text: text,
                style: style,
                blankSpace: blankSpace,
                velocity: 30,
              ),
            ),
          );
        }

        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: Text(
            text,
            maxLines: 1,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  bool _willTextOverflow({
    required String text,
    required TextStyle? style,
    required double maxWidth,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
