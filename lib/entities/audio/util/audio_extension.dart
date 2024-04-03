import 'package:sonify_client/sonify_client.dart';

import '../../../shared/util/assemble_resource_url.dart';

extension AudioX on Audio {
  Uri? get imageUri {
    if (thumbnailPath != null) {
      return Uri.tryParse(assembleResourceUrl(thumbnailPath!));
    } else if (thumbnailUrl != null) {
      return Uri.tryParse(thumbnailUrl!);
    }

    return null;
  }
}
