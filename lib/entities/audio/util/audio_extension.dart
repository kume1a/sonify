import 'package:domain_data/domain_data.dart';

import '../../../shared/util/assemble_resource_url.dart';

extension AudioX on Audio? {
  Uri? get thumbnailUri {
    if (this == null) {
      return null;
    }

    if (this!.thumbnailPath != null) {
      return Uri.tryParse(assembleResourceUrl(this!.thumbnailPath!));
    } else if (this!.thumbnailUrl != null) {
      return Uri.tryParse(this!.thumbnailUrl!);
    }

    return null;
  }
}
