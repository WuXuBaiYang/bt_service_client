/*
* QBittorrent请求响应
* @author jtechjh
* @Time 2021/5/6 10:15 AM
*/
class QBResponseModel {
  int _code;
  String _message;
  dynamic _data;

  int get code => _code;

  String get message => _message;

  dynamic get data => _data;

  QBResponseModel(this._code, this._message, this._data);

  /*
  * 成功对象构造
  * @author jtechjh
  * @Time 2021/5/6 10:15 AM
  */
  QBResponseModel.success(this._data, {int code = 0, String message = ""}) {
    this._message = message;
    this._code = code;
  }

  /*
  * 失败对象构造
  * @author jtechjh
  * @Time 2021/5/6 10:16 AM
  */
  QBResponseModel.failure(this._code, this._message, {dynamic data}) {
    this._data = data;
  }

  //判断是否成功
  bool get success => _code == 0;
}
