import 'dart:io';

import 'package:path_provider/path_provider.dart';

/*
* 文件路径管理工具
* @author jtechjh
* @Time 2021/5/14 11:20 上午
*/
class FileTools {
  //获取应用存储路径
  static Future<String> getDocumentPath({String path}) async {
    var dir = await getApplicationDocumentsDirectory();
    return _getPath(dir, path);
  }

  //获取应用缓存路径
  static Future<String> getCachePath({String path}) async {
    var dir = await getExternalStorageDirectory();
    return _getPath(dir, path);
  }

  //处理/拼接路径
  static Future<String> _getPath(Directory dir, String path) async {
    if (null != path) {
      path = "${dir.path}${path.startsWith("/") ? path : "/$path"}";
      dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }
    return dir?.path ?? "";
  }
}
