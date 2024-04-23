import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_like.freezed.dart';

@freezed
class AudioLike with _$AudioLike {
  const factory AudioLike({
    required int? localId,
    required String? audioId,
    required String? userId,
  }) = _AudioLike;
}
