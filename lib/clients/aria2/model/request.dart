import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/foundation.dart';

/*
* aria2请求对象
* @author jtechjh
* @Time 2021/5/7 10:11 AM
*/
class Aria2RequestModel {
  String _jsonRPC;
  String _method;
  String _id;
  dynamic _params;

  String get jsonRPC => _jsonRPC;

  String get method => _method;

  String get id => _id;

  dynamic get params => _params;

  //构建请求对象
  Aria2RequestModel.build({
    @required String method,
    @required dynamic params,
    String id,
    String jsonRPC = "2.0",
  }) {
    this._id = id ?? Tools.generationID;
    this._method = method;
    this._params = params;
    this._jsonRPC = jsonRPC;
  }

  toJson() => {
        "jsonrpc": _jsonRPC,
        "method": _method,
        "id": _id,
        "params": _params,
      };
}
