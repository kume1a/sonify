import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbBatchProvider {
  DbBatchProvider(this._batch);

  final Batch _batch;

  Batch get get => _batch;

  Future<void> commit() => _batch.commit(noResult: true);
}

abstract interface class DbBatchProviderFactory {
  DbBatchProvider newBatchProvider();
}

class SqfliteBatchProviderFactory implements DbBatchProviderFactory {
  SqfliteBatchProviderFactory(this._database);

  final Database _database;

  @override
  DbBatchProvider newBatchProvider() {
    return DbBatchProvider(_database.batch());
  }
}
