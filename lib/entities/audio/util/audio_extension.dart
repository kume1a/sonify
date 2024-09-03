import 'package:domain_data/domain_data.dart';

import '../../../shared/util/utils.dart';

extension AudioX on Audio? {
  Uri? thumbnailUri({required String apiUrl}) {
    if (this == null) {
      return null;
    }

    if (this!.localThumbnailPath.notNullOrEmpty) {
      return Uri.tryParse('$apiUrl/${this!.localThumbnailPath!}');
    } else if (this!.thumbnailPath.notNullOrEmpty) {
      return Uri.tryParse('$apiUrl/${this!.thumbnailPath!}');
    } else if (this!.thumbnailUrl.notNullOrEmpty) {
      return Uri.tryParse(this!.thumbnailUrl!);
    }

    return null;
  }

  Uri? audioUri({required String apiUrl}) {
    if (this == null) {
      return null;
    }

    if (this!.localPath.notNullOrEmpty) {
      return Uri.tryParse('$apiUrl/${this!.localPath!}');
    }

    return Uri.tryParse('$apiUrl/${this!.path}');
  }
}
