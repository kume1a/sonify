import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/audio/model/upload_user_local_music_params.dart';
import '../entity/audio/model/user_audio_dto.dart';

class MultipartApiClient {
  MultipartApiClient(
    this._dio,
    this._baseUrl,
  );

  final Dio _dio;
  final String? _baseUrl;

  Future<UserAudioDto> importUserLocalMusic(UploadUserLocalMusicParams params) async {
    final formData = FormData();

    formData.fields.add(MapEntry('localId', params.localId));
    formData.fields.add(MapEntry('title', params.title));
    if (params.author != null) {
      formData.fields.add(MapEntry('author', params.author!));
    }
    if (params.durationMs != null) {
      formData.fields.add(MapEntry('durationMs', params.durationMs.toString()));
    }

    formData.files.add(MapEntry(
      'audio',
      MultipartFile.fromBytes(params.audio, filename: 'audio'),
    ));
    if (params.thumbnail != null) {
      formData.files.add(MapEntry(
        'thumbnail',
        MultipartFile.fromBytes(params.thumbnail!, filename: 'thumbnail.png'),
      ));
    }

    final result = await _requestForm(
      formData,
      method: HttpMethod.POST,
      path: '/v1/audio/uploadUserLocalMusic',
    );

    return UserAudioDto.fromJson(result.data!);
  }

  Future<Response<Map<String, dynamic>>> _requestForm<T>(
    FormData formData, {
    required String method,
    required String path,
  }) {
    return _dio.fetch<Map<String, dynamic>>(
      _setStreamType<T>(
        Options(method: method)
            .compose(_dio.options, path, data: formData)
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
