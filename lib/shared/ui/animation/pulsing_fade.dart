import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _kCycleDuration = Duration(milliseconds: 500);

class PulsingFade extends HookWidget {
  const PulsingFade({
    super.key,
    required this.child,
    this.cycleDuration = _kCycleDuration,
  }) : isSliver = false;

  const PulsingFade.sliver({
    super.key,
    required this.child,
    this.cycleDuration = _kCycleDuration,
  }) : isSliver = true;

  final Widget child;
  final bool isSliver;
  final Duration cycleDuration;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: cycleDuration,
    )..repeat(reverse: true);

    final Animation<double> animation = useMemoized(() => Tween<double>(
          begin: .45,
          end: 1,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
        )));

    return AnimatedBuilder(
      builder: (_, Widget? child) {
        return isSliver
            ? SliverOpacity(
                opacity: animation.value,
                sliver: child,
              )
            : Opacity(
                opacity: animation.value,
                child: child,
              );
      },
      animation: animation,
      child: child,
    );
  }
}
