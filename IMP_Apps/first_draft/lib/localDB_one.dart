import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalDB {
  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/myfile.txt');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<File> deleteFromFile() async {
    final file = await getFile;
    file.delete(recursive: false);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String localDBUsername = await file.readAsString();
      return localDBUsername;
    } catch (e) {
      return "";
    }
  }
}
