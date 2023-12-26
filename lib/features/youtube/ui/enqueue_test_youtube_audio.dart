import 'package:flutter/material.dart';

import '../../../entities/audio/model/remote_audio_file.dart';
import '../../download_file/model/download_task.dart';
import '../../download_file/model/file_type.dart';
import '../../download_file/state/downloads_state.dart';

final _testUrl = Uri.parse(
    'https://rr1---sn-h5bupjvh-ucnr.googlevideo.com/videoplayback?expire=1703602582&ei=NpWKZZKdJvPmi9oPqYqgyAU&ip=93.177.158.13&id=o-APnRkKuxs6L27_h_np8TzDZ4XHuUuYHbFsKWGdD6QvPk&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=4D&mm=31%2C26&mn=sn-h5bupjvh-ucnr%2Csn-4g5lznez&ms=au%2Conr&mv=m&mvi=1&pl=22&gcr=ge&initcwndbps=2005000&vprv=1&mime=audio%2Fwebm&gir=yes&clen=65883109&dur=4220.021&lmt=1701124835402463&mt=1703580781&fvip=1&keepalive=yes&fexp=24007246&c=ANDROID_TESTSUITE&txp=5432434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRQIhANEMZyxQvFRThtCMnCqLx7X1_AI_OrP_ZAP911AeVj8CAiAN_jK9EgvUq7uPh5v7kE9YHbOzb7dGIQTWIj7IFjsNTQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AAO5W4owRQIhAKxLhm4hVI4vMisRyWcPK45_GugJIkHOvQiq_PFQN8xdAiA9tUytR4my8UUVljOBl6cqXFA5ZlW4ThqRzlu_wZbp3g%3D%3D');

class EnqueueTestYoutubeAudio extends StatelessWidget {
  const EnqueueTestYoutubeAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final downloadTask = DownloadTask(
          uri: _testUrl,
          savePath: '/data/user/0/com.kume1a.sonify/app_flutteraudioMp3/491b19e4-64f2-409d-909cbafa01c14.mp3',
          progress: 0.0,
          speedInKbs: 0,
          fileType: FileType.audioMp3,
          state: DownloadTaskState.idle,
          payload: DownloadTaskPayload(
            remoteAudioFile: RemoteAudioFile(
              title: 'Rammstein - Du Hast (Official 4K Video)',
              uri: _testUrl,
              sizeInKb: 3624,
              author: 'Rammstein Official',
              imageUri: Uri.parse('https://img.youtube.com/vi/W3q8Od5qJio/sddefault.jpg'),
            ),
          ),
        );

        context.downloadsCubit.enqueue(downloadTask);
      },
      child: const Text('Enqueue'),
    );
  }
}
