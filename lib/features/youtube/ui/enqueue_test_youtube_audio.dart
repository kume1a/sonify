import 'package:flutter/material.dart';

import '../../../entities/audio/model/remote_audio_file.dart';
import '../../download_file/model/download_task.dart';
import '../../download_file/model/file_type.dart';
import '../../download_file/state/downloads_state.dart';

final _testUrl = Uri.parse(
    'https://rr1---sn-h5bupjvh-ucnd.googlevideo.com/videoplayback?expire=1703547856&ei=cL-JZaH7LL3D6dsPmvGgkAQ&ip=93.177.158.13&id=o-AIfHFPAWhWi7necI-41V1JPGABnv4mS2aQMt0h6e1wHB&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=-s&mm=31%2C26&mn=sn-h5bupjvh-ucnd%2Csn-4g5e6nze&ms=au%2Conr&mv=m&mvi=1&pl=22&initcwndbps=1018750&vprv=1&mime=audio%2Fwebm&gir=yes&clen=72591867&dur=4646.041&lmt=1682383161931539&mt=1703525833&fvip=3&keepalive=yes&fexp=24007246&c=ANDROID_TESTSUITE&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRQIgGCWtdCEZjzewBSlnS9Ut1D3jTyOuRMf4CZjJ32gI-_0CIQCV5ryB2gDw5SLSLyk_qGxlSZUGqiRDlBxToMx1qT_sEA%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AAO5W4owRgIhAPhc4W1M9E_mlRXJlpl8j650G8eWFRYkGA6Ay9oNoNXYAiEA7Ajv5TGwUQF64vhLmOay49PCHAkAvYL7R2bDYpVi2Mc%3D');

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
