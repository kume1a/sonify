import 'dart:async';

import 'package:sqflite_common/sqlite_api.dart';

import 'migrate_to_v2.dart';

typedef MigrationFunction = FutureOr<void> Function(Batch batch);

const Map<int, MigrationFunction> migrationsMap = {
  2: migrateToV2,
};
