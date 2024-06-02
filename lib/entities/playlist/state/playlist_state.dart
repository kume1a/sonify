import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/cubit/entity_loader_cubit.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;

  String? _playlistId;

  void init(String playlistId) {
    _playlistId = playlistId;

    loadEntityAndEmit();
  }

  @override
  Future<Playlist?> loadEntity() async {
    if (_playlistId == null) {
      Logger.root.warning('PlaylistCubit.loadEntity: _playlistId is null');
      return null;
    }

    Logger.root.info('local playlist entity: ${await _playlistLocalRepository.getById(_playlistId!)}');

    final res = await _playlistRemoteRepository.getById(_playlistId!);

    if (res.isRight) {
      return res.rightOrNull;
    }

    final localRes = await _playlistLocalRepository.getById(_playlistId!);

    return localRes.dataOrNull;
  }
}
