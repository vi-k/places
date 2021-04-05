import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:places/data/repositories/upload/resize_image.dart';

import 'upload_repository.dart';

/// Иммитация загрузки фотографий.
class MockUploadRepository extends UploadRepository {
  const MockUploadRepository();

  /// Загрузка фотографий на сервер.
  @override
  Future<String?> uploadPhoto(File file) async {
    final sw = Stopwatch()..start();

    // Уменьшаем размер фотографии.
    final jpeg = await resizePhotoOnIsolate(file);
    if (jpeg == null) return null;

    sw.stop();
    debugPrint('resize photo: ${sw.elapsed}');

    debugPrint('file:/${file.path}');

    return 'file:/${file.path}';
  }
}
