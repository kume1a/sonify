import 'package:common_models/common_models.dart';

abstract interface class DeleteUnusedLocalAudio {
  Future<EmptyResult> deleteById(String id);

  Future<EmptyResult> deleteByIds(List<String> ids);
}
