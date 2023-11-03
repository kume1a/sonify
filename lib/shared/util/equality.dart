import 'package:collection/collection.dart';

bool notDeepEquals(dynamic a, dynamic b) {
  return !const DeepCollectionEquality().equals(a, b);
}
