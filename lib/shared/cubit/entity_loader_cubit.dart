import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract base class EntityWithFailureCubit<F, T> extends Cubit<DataState<F, T>> {
  EntityWithFailureCubit() : super(DataState.idle());

  @protected
  Future<Either<F, T>> loadEntity();

  Future<void> onRefresh() => loadEntityAndEmit();

  @protected
  Future<void> loadEntityAndEmit() async {
    final T? previousData = state.getOrNull;

    emit(DataState<F, T>.loading());

    final entity = await loadEntity();

    if (isClosed) {
      return;
    }

    entity.fold(
      (F failure) => emit(DataState.failure(failure, previousData)),
      (T data) => emit(DataState.success(data)),
    );
  }
}

abstract base class EntityLoaderCubit<T> extends Cubit<SimpleDataState<T>> {
  EntityLoaderCubit() : super(SimpleDataState.idle());

  @protected
  Future<T?> loadEntity();

  Future<void> onRefresh() => loadEntityAndEmit();

  @protected
  Future<void> loadEntityAndEmit() async {
    final T? previousData = state.getOrNull;

    emit(SimpleDataState<T>.loading());

    final T? optionalEntity = await loadEntity();

    if (isClosed) {
      return;
    }

    if (optionalEntity == null) {
      emit(SimpleDataState.failure(previousData));
      return;
    }

    emit(SimpleDataState.success(optionalEntity));
  }
}
