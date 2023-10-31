import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

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
  MainPageCubit() : super(MainPageState.initial());

  void onPageChanged(int index) {
    emit(state.copyWith(pageIndex: index));
  }
}
