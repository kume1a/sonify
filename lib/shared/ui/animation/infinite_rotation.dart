import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../util/utils.dart';

class InfiniteRotation extends HookWidget {
  const InfiniteRotation({
    super.key,
    required this.child,
    required this.duration,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: duration,
    );

    final animation = useMemoized(
      () => Tween<double>(
        begin: 0,
        end: deg2rad(360),
      ).animate(animationController),
      [],
    );

    useEffect(() {
      animationController.forward();
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.repeat();
        }
      });

      return null;
    }, []);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Transform.rotate(
        angle: animation.value,
        child: child,
      ),
      child: child,
    );
  }
}
