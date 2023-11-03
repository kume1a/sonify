import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract interface class UuidFactory {
  String generate();
}

@LazySingleton(as: UuidFactory)
class UuidFactoryImpl implements UuidFactory {
  UuidFactoryImpl(this._uuid);

  final Uuid _uuid;

  @override
  String generate() {
    return _uuid.v4();
  }
}
