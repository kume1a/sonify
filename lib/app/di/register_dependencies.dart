import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'register_dependencies.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> registerDependencies(
  String env,
) async {
  await getIt.init(environment: env);
}
