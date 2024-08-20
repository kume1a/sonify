import 'dart:async';

import 'package:sqflite/sqflite.dart';

FutureOr<void> migrateToV2(Batch batch) {
  batch.execute('''
    CREATE TABLE IF NOT EXISTS hidden_user_audios 
    (
      id TEXT PRIMARY KEY NOT NULL,
      created_at_millis INTEGER, 
      user_id TEXT,
      audio_id TEXT
    );
  ''');
}
