import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

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
  static String get generationID => base64En(
      "JTech_BT_Service_Client_${DateTime.now().millisecondsSinceEpoch}_${Random(99999).nextDouble()}");
}
