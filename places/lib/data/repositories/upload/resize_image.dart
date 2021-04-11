import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart';
import 'package:places/logger.dart';

/// Изменяет размер и качество фотографии под заданный размер (в байтах).
Future<List<int>?> resizePhotoOnIsolate(
  File file, {
  int maxWidth = 1000,
  int maxHeight = 1000,
  int maxSizeInBytes = 1000000,
}) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _resizePhoto,
    _ResizeParam(
      file: file,
      sendPort: receivePort.sendPort,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      maxSizeInBytes: maxSizeInBytes,
    ),
  );

  return await receivePort.first as List<int>?;
}

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

void _resizePhoto(_ResizeParam param) {
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

  logger.d('src image: ${srcWidth}x$srcHeight');

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

  logger.d('new image: ${image.width}x${image.height}');

  // Сжимаем до тех пор, пока размер картники не станет подходящим.
  List<int> jpeg;
  var quality = param.maxQuality;

  do {
    jpeg = encodeJpg(image, quality: quality);
    logger.d('quality: $quality size: ${jpeg.length}');
    quality--;
  } while (param.maxSizeInBytes != null && jpeg.length > param.maxSizeInBytes!);

  print(jpeg.runtimeType);
  param.sendPort.send(jpeg);
}
