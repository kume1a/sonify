import 'package:common_models/common_models.dart';

import '../model/audio.dart';

abstract interface class AudioLocalRepository {
  Future<Result<Audio>> save(Audio audio);

  Future<Result<List<Audio>>> getByIds(List<String> audioIds);
}
