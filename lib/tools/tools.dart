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
}
