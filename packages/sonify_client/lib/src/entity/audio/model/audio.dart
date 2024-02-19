import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio.freezed.dart';

@freezed
class Audio with _$Audio {
  const factory Audio({
    required String id,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required String? title,
    required int duration,
    required String path,
    required String author,
    required String userId,
  }) = _Audio;
}
