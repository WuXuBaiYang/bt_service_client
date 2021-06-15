import 'package:flutter/foundation.dart';

/*
* transmission请求对象
* @author jtechjh
* @Time 2021/5/7 10:11 AM
*/
class TMRequestModel {
  String _method;
  dynamic _arguments;

  //构建请求对象
  TMRequestModel.build({
    @required String method,
    @required dynamic arguments,
  }) {
    this._method = method;
    this._arguments = arguments;
  }

  toJson() => {
        "method": _method,
        "arguments": _arguments,
      };
}
