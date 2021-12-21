import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:places/data/repositories/upload/resize_image.dart';
import 'package:places/logger.dart';

import 'upload_repository.dart';

/// Загрузка фотографий на сервер.
class ApiUploadRepository extends UploadRepository {
  const ApiUploadRepository(this.dio);

  final Dio dio;

  /// Загрузка фотографий на сервер.
  @override
  Future<String?> uploadPhoto(File file) async {
    final sw = Stopwatch()..start();

    // Уменьшаем размер фотографии.
    final jpeg = await resizePhotoOnIsolate(file);
    if (jpeg == null) return null;

    sw.stop();
    logger.d('resize photo: ${sw.elapsed}');

    // Загружаем на сервер.
    sw
      ..reset()
      ..start();

    final formData = FormData.fromMap(
      <String, Object>{
        'files': MultipartFile.fromBytes(
          jpeg,
          contentType: MediaType('image', 'jpeg'),
        ),
      },
    );

    final response = await dio.post<String>('/upload_file', data: formData);
    final location = response.headers.value('location');

    sw.stop();
    logger.d('upload photo: ${sw.elapsed} (location: $location)');

    if (location == null) return null;

    return join(dio.options.baseUrl, location);
  }
}
