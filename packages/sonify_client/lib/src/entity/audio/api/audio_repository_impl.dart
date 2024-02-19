import 'package:common_models/common_models.dart';
import 'package:common_network_components/common_network_components.dart';

import '../../../api/api_client.dart';
import '../model/audio.dart';
import '../model/download_youtube_audio_body.dart';
import '../util/audio_mapper.dart';
import 'audio_repository.dart';

class AudioRepositoryImpl with SafeHttpRequestWrap implements AudioRepository {
  AudioRepositoryImpl(
    this._apiClient,
    this._audioMapper,
  );

  final ApiClient _apiClient;
  final AudioMapper _audioMapper;

  @override
  Future<Either<ActionFailure, Audio>> downloadYoutubeAudio(String videoId) {
    return callCatchWithActionFailure(
      () async {
        final body = DownloadYoutubeAudioBody(videoId: videoId);

        final res = await _apiClient.downloadYoutubeAudio(body);

        return _audioMapper.dtoToModel(res);
      },
    );
  }
}
