import 'package:bt_service_manager/tools/tools.dart';

/*
* aria2请求响应对象
* @author jtechjh
* @Time 2021/5/7 10:14 AM
*/
class Aria2ResponseModel {
  String _id;
  String _jsonRPC;
  dynamic _result;
  Aria2ErrorModel _error;

  String get id => _id;

  String get jsonRPC => _jsonRPC;

  dynamic get result => _result;

  Aria2ErrorModel get error => _error;

  //判断是否请求成功
  bool get success => null != _error;

  //失败响应
  Aria2ResponseModel.failure(
    int code,
    String message, {
    String id,
    String jsonRPC = "2.0",
  }) {
    this._id = id ?? Tools.generationID;
    this._jsonRPC = jsonRPC;
    this._error = Aria2ErrorModel.build(code, message);
  }

  Aria2ResponseModel.fromJson(dynamic json) {
    _id = json["id"];
    _jsonRPC = json["jsonrpc"];
    _result = json["result"];
    _error =
        json["error"] != null ? Aria2ErrorModel.fromJson(json["error"]) : null;
  }
}

/*
* aria2请求响应异常对象
* @author jtechjh
* @Time 2021/5/7 10:15 AM
*/
class Aria2ErrorModel {
  int _code;
  String _message;

  int get code => _code;

  String get message => _message;

  //构建对象
  Aria2ErrorModel.build(this._code, this._message);

  Aria2ErrorModel.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
  }
}
