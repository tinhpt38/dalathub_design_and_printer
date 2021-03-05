import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileIO {
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<File> write({String fileName, String value}) async {
    final file = await _localFile(fileName);
    return file.writeAsString('$value');
  }

  Future<String> readFile(String name) async {
    try {
      final file = await _localFile(name);
      String content = await file.readAsString();
      return content;
    } catch (_) {
      return null;
    }
  }
}
