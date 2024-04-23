import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'create_tables.dart';
import 'migrations/migrations_map.dart';

class DbFactory {
  static const String _databaseName = 'literature.db';

  static Future<Database> create() async {
    final Database database = await openDatabase(
      _databaseName,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  static FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = OFF');
  }

  static FutureOr<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    createDbTables(batch);

    await batch.commit();
  }

  static FutureOr<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) {
    final Batch batch = db.batch();

    for (int i = oldVersion + 1; i <= newVersion; i++) {
      migrationsMap[i]?.call(batch);
    }

    batch.commit();
  }
}
