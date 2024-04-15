import 'package:domain_data/domain_data.dart';

import '../../../shared/util/assemble_resource_url.dart';
import '../../../shared/util/utils.dart';

extension AudioX on Audio? {
  Uri? get thumbnailUri {
    if (this == null) {
      return null;
    }

    if (this!.localThumbnailPath.notNullOrEmpty) {
      return Uri.tryParse(this!.localThumbnailPath!);
    } else if (this!.thumbnailPath.notNullOrEmpty) {
      return Uri.tryParse(assembleResourceUrl(this!.thumbnailPath!));
    } else if (this!.thumbnailUrl.notNullOrEmpty) {
      return Uri.tryParse(this!.thumbnailUrl!);
    }

    return null;
  }

  Uri? get audioUri {
    if (this == null) {
      return null;
    }

    if (this!.localPath.notNullOrEmpty) {
      return Uri.tryParse(this!.localPath!);
    }

    return Uri.tryParse(assembleResourceUrl(this!.path));
  }
}
