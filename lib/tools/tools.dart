import 'dart:convert';
import 'dart:math';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/*
* 工具包
* @author jtechjh
* @Time 2021/5/6 2:01 PM
*/
class Tools {
  //转换为md5
  static String toMD5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  //Base64加密
  static String base64En(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  //Base64解密
  static String base64De(String data) {
    var bytes = base64Decode(data);
    var result = utf8.decode(bytes);
    return result;
  }

  //生成唯一id
  static String get generationID => toMD5(base64En(
      "JTech_BT_Service_Client_${DateTime.now().millisecondsSinceEpoch}_${Random(99999).nextDouble()}"));

  //复制到剪切板
  static Future<void> clipboard(String text, {String message = ""}) async {
    if (null == text || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (message.isNotEmpty) AlertTools.snack(message);
  }

  //字节单位表
  static final Map<String, num> _byteMap = {
    "B": 1,
    "KB": 1024,
    "MB": 1024 * 1024,
    "GB": 1024 * 1024 * 1024,
    "TB": 1024 * 1024 * 1024 * 1024,
    "PB": 1024 * 1024 * 1024 * 1024 * 1024,
  };

  //转换字节单位，获取文字
  static String convertByte(num byte, {bool lower = false, int fixed = 2}) {
    String text = "";
    if (byte >= 1024) {
      for (int i = _byteMap.keys.length - 1; i >= 0; i--) {
        var key = _byteMap.keys.elementAt(i);
        var value = _byteMap[key];
        if (byte >= value) {
          num size = byte / value;
          text = "${size.toStringAsFixed(fixed)} $key";
          break;
        }
      }
    } else {
      text = "$byte B";
    }
    if (lower) return text.toLowerCase();
    return text;
  }
}

/*
* Assets文件目录枚举
* @author jtechjh
* @Time 2021/5/18 3:04 下午
*/
enum AssetsFile {
  Config,
  Icons,
  Images,
}

/*
* 扩展输出Assets文件目录
* @author jtechjh
* @Time 2021/5/18 3:04 下午
*/
extension AssetsFileExtension on AssetsFile {
  //获取Assets对应目录
  String get path {
    switch (this) {
      case AssetsFile.Config:
        return "lib/assets/config/";
      case AssetsFile.Icons:
        return "lib/assets/icons/";
      case AssetsFile.Images:
        return "lib/assets/images/";
    }
    return "";
  }
}
