import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

class _ResizeParam {
  _ResizeParam({
    required this.file,
    required this.sendPort,
    this.maxWidth,
    this.maxHeight,
    this.maxSizeInBytes,
    this.maxQuality = 100,
  });

  final File file;
  final SendPort sendPort;
  final int? maxWidth;
  final int? maxHeight;
  final int? maxSizeInBytes;
  final int maxQuality;
}

/// Загрузка фотографий на сервер.
Future<String?> uploadPhoto(Dio dio, File file) async {
  final sw = Stopwatch()..start();

  final receivePort = ReceivePort();

  await Isolate.spawn(
    _resizePhotoOnIsolate,
    _ResizeParam(
      file: file,
      sendPort: receivePort.sendPort,
      maxWidth: 1000,
      maxHeight: 1000,
      maxSizeInBytes: 1000000,
    ),
  );

  final jpeg = await receivePort.first as List<int>?;
  if (jpeg == null) return null;

  sw.stop();
  debugPrint('uploadImage.resizeOnIsolate: ${sw.elapsed}');

  sw..reset()..start();

  final formData = FormData.fromMap(<String, Object>{
    'files': MultipartFile.fromBytes(
      jpeg,
      contentType: MediaType('image', 'jpeg'),
    )
  });

  final response = await dio.post<String>('/upload_file', data: formData);
  final location = response.headers.value('location');

  sw.stop();
  debugPrint('uploadImage.post: ${sw.elapsed} (location: $location)');

  if (location == null) return null;

  final url = join(dio.options.baseUrl, location);

  return url;
}

/// Меняем размер фотографии.
void _resizePhotoOnIsolate(_ResizeParam param) {
  var image = decodeImage(param.file.readAsBytesSync());
  if (image == null) return;

  // Фотография может быть повёрнута на бок.
  int srcWidth;
  int srcHeight;
  if (!image.exif.hasOrientation || image.exif.orientation & 1 == 1) {
    srcWidth = image.width;
    srcHeight = image.height;
  } else {
    srcWidth = image.height;
    srcHeight = image.width;
  }
  final aspectRatio = srcWidth / srcHeight;

  debugPrint('src image: ${srcWidth}x$srcHeight');

  // Уменьшаем размер до макисмально возможного.
  var destWidth = param.maxWidth ?? srcWidth;
  var destHeight = param.maxHeight ?? srcHeight;

  if (destWidth / aspectRatio > destHeight) {
    destWidth = (destHeight * aspectRatio).round();
  } else if (destHeight * aspectRatio > destWidth) {
    destHeight = (destWidth / aspectRatio).round();
  }

  image = copyResize(
    image,
    width: destWidth,
    height: destHeight,
    interpolation: Interpolation.cubic,
  );

  debugPrint('new image: ${image.width}x${image.height}');

  // Сжимаем до тех пор, пока размер картники не станет подходящим
  // (ограничения по размеру картинки ~1Мб).
  List<int> jpeg;
  var quality = param.maxQuality;

  do {
    jpeg = encodeJpg(image, quality: quality);
    debugPrint('quality: $quality size: ${jpeg.length}');
    quality--;
  } while (param.maxSizeInBytes != null && jpeg.length > param.maxSizeInBytes!);

  param.sendPort.send(jpeg);
}
