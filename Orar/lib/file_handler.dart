import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  static Future<Directory> getRoot() async {
    return await getApplicationDocumentsDirectory();
  }
}
