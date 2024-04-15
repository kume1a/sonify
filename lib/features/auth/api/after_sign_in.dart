import 'package:domain_data/domain_data.dart';

abstract interface class AfterSignIn {
  Future<void> call({
    required TokenPayload tokenPayload,
  });
}
