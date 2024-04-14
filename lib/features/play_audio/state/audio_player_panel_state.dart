import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'audio_player_panel_state.freezed.dart';

@freezed
class AudioPlayerPanelState with _$AudioPlayerPanelState {
  const factory AudioPlayerPanelState({
    required bool isPanelOpen,
  }) = _AudioPlayerPanelState;

  factory AudioPlayerPanelState.initial() => const AudioPlayerPanelState(
        isPanelOpen: false,
      );
}

extension AudioPlayerPanelCubitX on BuildContext {
  AudioPlayerPanelCubit get audioPlayerPanelCubit => read<AudioPlayerPanelCubit>();
}

@injectable
class AudioPlayerPanelCubit extends Cubit<AudioPlayerPanelState> {
  AudioPlayerPanelCubit() : super(AudioPlayerPanelState.initial());

  final panelController = PanelController();

  void onMiniAudioPlayerPanelPressed() {
    if (panelController.isAttached) {
      panelController.open();
    }
  }

  void onDownArrowPressed() {
    if (panelController.isAttached) {
      panelController.close();
    }
  }
}
