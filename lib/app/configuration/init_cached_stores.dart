import '../../entities/server_time/api/get_server_time.dart';
import '../di/register_dependencies.dart';

Future<void> initCachedStores() async {
  await getIt<GetServerTime>().call();
}
