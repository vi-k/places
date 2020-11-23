import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  await HttpClient()
      .getUrl(Uri.parse('http://example.com/'))
      .then((request) => request.close())
      .then<dynamic>((response) => response.transform(utf8.decoder).forEach(print));

  Future<File> getImageFromWeb(String url) async {
    final file = File('./image.jpg');
    var first = true;
    await HttpClient()
      .getUrl(Uri.parse(url))
      .then((request) => request.close())
      .then<dynamic>((response) => response.forEach((element) {
          file.writeAsBytesSync(element, mode: first ? FileMode.write : FileMode.append);
          first = false;
        }));
    return file;
  }

  final file = await getImageFromWeb('https://i.pinimg.com/564x/e6/57/1a/e6571a6c62fb2615c741a8fcf32aef49.jpg');
  print(file.lengthSync());
}
