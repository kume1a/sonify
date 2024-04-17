import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../api/sync_user_audio.dart';

@injectable
class SyncUserAudioCubit extends Cubit<Unit> {
  SyncUserAudioCubit(
    this._syncUserAudio,
  ) : super(unit) {
    _init();
  }

  final SyncUserAudio _syncUserAudio;

  Future<void> _init() async {}
}
