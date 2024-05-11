import 'package:common_models/common_models.dart';

abstract interface class SyncUserPendingChanges {
  Future<EmptyResult> call();
}
