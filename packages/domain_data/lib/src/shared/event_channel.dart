import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:sonify_client/sonify_client.dart';

abstract class EventChannel<T> {
  Stream<T> get events;

  Future<void> startListening();

  Future<void> dispose();

  FutureOr<T> map(Map<String, dynamic> payload);
}

class _WsPayloadDto {
  _WsPayloadDto({
    required this.messageType,
    required this.payload,
  });

  factory _WsPayloadDto.fromJson(Map<String, dynamic> json) {
    return _WsPayloadDto(
      messageType: json['messageType'] as String,
      payload: json['payload'],
    );
  }

  final String messageType;
  final dynamic payload;
}

abstract base class WsEventChannel<T> implements EventChannel<T> {
  WsEventChannel(
    this._socketProvider,
  );

  final SocketProvider _socketProvider;

  @protected
  String get messageType;

  final StreamController<T> streamController = StreamController<T>();

  @override
  @nonVirtual
  Stream<T> get events => streamController.stream;

  StreamSubscription? _subscription;

  @override
  @protected
  FutureOr<T> map(Map<String, dynamic> payload);

  @override
  @nonVirtual
  Future<void> startListening() async {
    if (_subscription != null) {
      throw Exception('channel is already listening');
    }

    if (streamController.isClosed) {
      throw Exception('channel has been disposed');
    }

    final socket = await _socketProvider.socket;

    _subscription = socket?.messages.listen(_handleEvent);
  }

  @override
  @nonVirtual
  Future<void> dispose() async {
    await _subscription?.cancel();
    await streamController.close();
  }

  Future<void> _handleEvent(dynamic payload) async {
    try {
      Logger.root.info('received payload: $payload');

      if (payload is! String) {
        log(
          '',
          error: 'invalid payload, expected string, got type: ${payload.runtimeType}, $payload',
        );
      }

      final json = jsonDecode(payload);

      final dto = _WsPayloadDto.fromJson(json);

      if (dto.messageType != messageType) {
        return;
      }

      if (dto.payload == null || dto.payload is! Map<String, dynamic>) {
        log('', error: 'invalid payload, expected non-null Map<String, dynamic>, got: ${dto.payload}, $dto');
        return;
      }

      final T mapped = await map(dto.payload);

      streamController.sink.add(mapped);
    } catch (e) {
      log('', error: e);
    }
  }
}
