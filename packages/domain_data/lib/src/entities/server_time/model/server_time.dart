import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_time.freezed.dart';

@freezed
class ServerTime with _$ServerTime {
  const factory ServerTime({
    required DateTime? time,
  }) = _ServerTime;
}
