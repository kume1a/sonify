import 'package:common_utilities/common_utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../model/event_main_navigation.dart';

part 'main_page_state.freezed.dart';

extension MainPageCubitX on BuildContext {
  MainPageCubit get mainPageCubit => read<MainPageCubit>();
}

@freezed
class MainPageState with _$MainPageState {
  const factory MainPageState({
    required int pageIndex,
  }) = _MainPageState;

  factory MainPageState.initial() => const MainPageState(
        pageIndex: 0,
      );
}

@injectable
class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit(
    this._eventBus,
  ) : super(MainPageState.initial()) {
    _init();
  }

  final EventBus _eventBus;

  final _subscriptions = SubscriptionComposite();

  void _init() {
    _subscriptions.addAll([
      _eventBus.on<EventMainNavigation>().listen(_onEventMainNavigation),
    ]);
  }

  @override
  Future<void> close() async {
    await _subscriptions.closeAll();

    return super.close();
  }

  void onPageChanged(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  void _onEventMainNavigation(EventMainNavigation event) {
    if (event.pageIndex < 0 || event.pageIndex > 2) {
      Logger.root.warning('Invalid page index: ${event.pageIndex}');
      return;
    }

    emit(state.copyWith(pageIndex: event.pageIndex));
  }
}
