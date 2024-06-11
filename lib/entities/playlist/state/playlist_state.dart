import 'package:common_models/common_models.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:domain_data/domain_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../../../features/download_file/model/downloads_event.dart';
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
    this._playlistCachedRepository,
    this._bottomSheetManager,
    this._eventBus,
  );

  final PlaylistCachedRepository _playlistCachedRepository;
  final BottomSheetManager _bottomSheetManager;
  final EventBus _eventBus;

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

    final res = await _playlistCachedRepository.getById(_playlistId!);

    return res.dataOrNull;
  }

  Future<void> onPlaylistAudioMenuPressed(PlaylistAudio playlistAudio) async {
    final selectedOption = await _bottomSheetManager.openOptionSelector<int>(
      header: (l) => playlistAudio.audio?.title ?? l.audio,
      options: [
        SelectOption(value: 0, label: (l) => l.download, iconAssetName: Assets.svgDownload),
      ],
    );

    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case 0:
        _eventBus.fire(DownloadsEvent.enqueuePlaylistAudio(playlistAudio));
        break;
    }
  }
}
