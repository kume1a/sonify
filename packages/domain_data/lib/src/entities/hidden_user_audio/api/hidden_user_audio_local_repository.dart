import 'package:common_models/common_models.dart';

import '../model/hidden_user_audio.dart';

abstract interface class HiddenUserAudioLocalRepository {
  Future<Result<HiddenUserAudio>> create(HiddenUserAudio hiddenUserAudios);

  Future<EmptyResult> bulkCreate(List<HiddenUserAudio> hiddenUserAudios);

  Future<Result<int>> deleteByIds(List<String> ids);
}
