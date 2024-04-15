import 'package:domain_data/domain_data.dart';

abstract interface class AuthUserInfoProvider {
  Future<String?> getId();

  Future<User?> read();

  Future<void> write(User user);

  Future<void> clear();
}
