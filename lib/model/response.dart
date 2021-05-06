/*
* 请求响应对象
* @author jtechjh
* @Time 2021/5/6 10:12 AM
*/
import 'package:flutter/cupertino.dart';

class ResponseModel {
  int _code;
  String _message;
  dynamic _data;

  int get code => _code;

  String get message => _message;

  dynamic get data => _data;

  ResponseModel(this._code, this._message, this._data);

  /*
  * 成功对象构造
  * @author jtechjh
  * @Time 2021/5/6 10:15 AM
  */
  ResponseModel.success(this._data, {int code = 0, String message = ""}) {
    this._message = message;
    this._code = code;
  }

  /*
  * 失败对象构造
  * @author jtechjh
  * @Time 2021/5/6 10:16 AM
  */
  ResponseModel.failure(this._code, this._message, {String message = ""}) {
    this._message = message;
  }

  //判断是否成功
  bool get success => _code == 0;
}
