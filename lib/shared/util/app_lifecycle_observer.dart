import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleObserver({
    this.onDetached,
    this.onHidden,
    this.onInactive,
    this.onPaused,
    this.onResumed,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  final VoidCallback? onDetached;
  final VoidCallback? onHidden;
  final VoidCallback? onInactive;
  final VoidCallback? onPaused;
  final VoidCallback? onResumed;

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        onHidden?.call();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        onPaused?.call();
        break;
      case AppLifecycleState.resumed:
        onResumed?.call();
        break;
    }
  }
}
