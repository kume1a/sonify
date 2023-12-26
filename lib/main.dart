import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'app/app.dart';
import 'app/di/register_dependencies.dart';
import 'app/navigation/page_navigator.dart';

// TODO fix ChunkDownloader dispose of streams
// TODO migrate downloads to a separate isolate
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  GlobalNavigator.navigatorKey = navigatorKey;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const App());
}


//  headers = {
//         'Accept': '*/*',
//         'Accept-Encoding': 'application/json',
//         'Accept-Language': 'en-GB,en-US;q=0.9,en;q=0.8',
//         'Referer': 'https://ytjar.downloader-ytjar.online/1.php',
//         'Sec-Ch-Ua': '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
//         'Sec-Ch-Ua-Mobile': '?0',
//         'Sec-Ch-Ua-Platform': '"macOS"',
//         'Sec-Fetch-Dest': 'empty',
//         'Sec-Fetch-Mode': 'cors',
//         'Sec-Fetch-Site': 'same-origin',
//         'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
//         'X-Requested-With': 'XMLHttpRequest',
//     }

//     res1 = requests.get('https://ytjar.downloader-ytjar.online/download1.php?id=n_LApFnTfP8', headers=headers)

//     print(json.loads(res1.text))