import 'package:domain_data/domain_data.dart';

import '../../../shared/util/assemble_resource_url.dart';

extension AudioX on Audio {
  Uri? get thumbnailUri {
    if (thumbnailPath != null) {
      return Uri.tryParse(assembleResourceUrl(thumbnailPath!));
    } else if (thumbnailUrl != null) {
      return Uri.tryParse(thumbnailUrl!);
    }

    return null;
  }
}
