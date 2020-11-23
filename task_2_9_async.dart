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
  var now = DateTime.now();

  await HttpClient()
      .getUrl(Uri.parse('http://example.com/'))
      .then((request) => request.close())
      .then<dynamic>((response) => response.transform(utf8.decoder).forEach(print));

  print('Request 1: ${DateTime.now().difference(now)}');

  Future<int> getImageFromWeb(String url) async {
    final file = File('./image.jpg');
    var first = true;
    await HttpClient()
      .getUrl(Uri.parse(url))
      .then((request) => request.close())
      .then<dynamic>((response) => response.forEach((element) {
          file.writeAsBytesSync(element, mode: first ? FileMode.write : FileMode.append);
          first = false;
        }));
    return file.length();
  }

  now = DateTime.now();
  final fileSize = await getImageFromWeb('https://i.pinimg.com/564x/e6/57/1a/e6571a6c62fb2615c741a8fcf32aef49.jpg');
  print(fileSize);
  print('Request 2: ${DateTime.now().difference(now)}');
}
