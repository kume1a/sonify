import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract base class EntityWithErrorCubit<E, T> extends Cubit<DataState<E, T>> {
  EntityWithErrorCubit() : super(DataState.idle());

  @protected
  Future<Either<E, T>> loadEntity();

  Future<void> onRefresh() => loadEntityAndEmit();

  @protected
  Future<void> loadEntityAndEmit() async {
    final T? previousData = state.getOrNull;

    emit(DataState<E, T>.loading());

    final entity = await loadEntity();

    if (isClosed) {
      return;
    }

    entity.fold(
      (E err) => emit(DataState.failure(err, previousData)),
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
  Future<void> loadEntityAndEmit({
    bool emitLoading = true,
  }) async {
    final T? previousData = state.getOrNull;

    if (emitLoading) {
      emit(SimpleDataState<T>.loading());
    }

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
