// Задание 1
// Используя Future, загрузите текстовый файл с ресурса "https://jsonplaceholder.typicode.com/posts&quot;;; или любой другой страницы с текстовыми данными. Для загрузки текста не обязательно использовать json парсинг данных. Можно представить данные в виде набора байт и декодировать при помощи utf8 декодера. Пример

// Загрузите картинку с ресурса "https://i.pinimg.com/564x/e6/57/1a/e6571a6c62fb2615c741a8fcf32aef49.jpg&quot;;;.  Для загрузки изображений в виде файла можно использовать следующий код
// Future getImageFromWeb(String url) {
//   var client = HttpClient();
//   var _downloadData = [];
//   var fileSave = File('./image.png');
//   return client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
//     return request.close();
//   }).then((HttpClientResponse response) async {
//     return response.first.then((value) {
//       _downloadData.addAll(value);
//       return fileSave.writeAsBytes(_downloadData);
//     });
//   });
// }
// Сравните время загрузки файлов, выведите на консоль
// Выведите скачанный текст и размер изображения в байтах на консоль
// Обрабатывать ошибки не обязательно. Это будет пройдено в "Продвинутое изучение Future"

import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final httpClient = HttpClient();

  final stopwatch = Stopwatch()..start();

  await httpClient
      .getUrl(Uri.parse('http://example.com/'))
      .then((request) => request.close())
      .then<dynamic>(
          (response) => response.transform(utf8.decoder).forEach(print));

  stopwatch.stop();
  httpClient.close();

  print('Request 1: ${stopwatch.elapsed}');

  Future<File> getImageFromWeb(String url, String filename) async {
    File file;
    final httpClient = HttpClient();
    await httpClient
        .getUrl(Uri.parse(url))
        .then((request) => request.close())
        .then<dynamic>((response) => response.forEach((element) {
              final first = file == null;
              file ??= File(filename);
              file.writeAsBytesSync(element,
                  mode: first ? FileMode.write : FileMode.append);
            }));
    httpClient.close();
    return file;
  }

  stopwatch
    ..reset()
    ..start();

  final file = await getImageFromWeb(
      'https://i.pinimg.com/564x/e6/57/1a/e6571a6c62fb2615c741a8fcf32aef49.jpg',
      './image.jpg');

  stopwatch.stop();
  print(file.lengthSync());

  print('Request 2: ${stopwatch.elapsed}');
}
