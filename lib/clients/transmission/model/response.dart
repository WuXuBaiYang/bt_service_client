/*
* transmission请求响应对象
* @author jtechjh
* @Time 2021/5/7 10:14 AM
*/
class TMResponseModel {
  dynamic _arguments;
  String _result;

  dynamic get arguments => _arguments;

  dynamic get result => _result;

  //判断是否请求成功
  bool get success => _result == "success";

  //失败响应
  TMResponseModel.failure(String message) {
    this._result = message;
  }

  TMResponseModel.fromJson(dynamic json) {
    _result = json["result"];
    _arguments = json["arguments"];
  }
}
