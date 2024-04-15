import 'package:common_models/common_models.dart';
import 'package:domain_data/domain_data.dart';
import 'package:injectable/injectable.dart';

import '../../../features/auth/api/auth_user_info_provider.dart';
import '../../../shared/cubit/entity_loader_cubit.dart';

typedef AuthUserState = SimpleDataState<User>;

@injectable
final class AuthUserCubit extends EntityLoaderCubit<User> {
  AuthUserCubit(
    this._authUserInfoProvider,
  ) {
    loadEntityAndEmit();
  }

  final AuthUserInfoProvider _authUserInfoProvider;

  @override
  Future<User?> loadEntity() async {
    return _authUserInfoProvider.read();
  }
}
