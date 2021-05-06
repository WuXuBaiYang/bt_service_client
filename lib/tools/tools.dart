import 'dart:convert';
import 'package:crypto/crypto.dart';

/*
* 工具包
* @author jtechjh
* @Time 2021/5/6 2:01 PM
*/
class Tools {
  //转换为md5
  static String toMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }
}
