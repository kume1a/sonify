import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../shared/bottom_sheet/bottom_sheet_manager.dart';
import '../../../shared/bottom_sheet/select_option/select_option.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';
import '../../../shared/values/assets.dart';

typedef PlaylistState = SimpleDataState<Playlist>;

extension PlaylistCubitX on BuildContext {
  PlaylistCubit get playlistCubit => read<PlaylistCubit>();
}

@injectable
final class PlaylistCubit extends EntityLoaderCubit<Playlist> {
  PlaylistCubit(
    this._playlistRemoteRepository,
    this._playlistLocalRepository,
    this._bottomSheetManager,
  );

  final PlaylistRemoteRepository _playlistRemoteRepository;
  final PlaylistLocalRepository _playlistLocalRepository;
  final BottomSheetManager _bottomSheetManager;

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

    final res = await _playlistRemoteRepository.getById(_playlistId!);

    if (res.isRight) {
      return res.rightOrNull;
    }

    final localRes = await _playlistLocalRepository.getById(_playlistId!);

    return localRes.dataOrNull;
  }

  Future<void> onPlaylistAudioMenuPressed(Audio audio) async {
    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (_) => audio.title,
      options: [
        SelectOption(value: 0, label: (l) => l.download, iconAssetName: Assets.svgDownload),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        Logger.root.info('Download audio: ${audio.id}');
        break;
    }
  }
}
