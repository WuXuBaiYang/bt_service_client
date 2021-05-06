import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 网络请求入口
* @author jtech
* @Time 2020/6/8 10:17 AM
*/
class API {
  static final API _instance = API._internal();

  factory API() => _instance;

  API._internal();

  //接口对象管理
  final Map<String, Map<String, dynamic>> _apis = {
    "aria2": {},
    "qb": {},
  };

  //aria2分流
  Aria2API getAria2(String baseUrl) {
    if (null == baseUrl || baseUrl.isEmpty) return null;
    if (!_apis["aria2"].containsKey(baseUrl)) {
      _apis["aria2"][baseUrl] = Aria2API(baseUrl);
    }
    return _apis["aria2"][baseUrl];
  }

  //qb分流
  QBAPI getQB(String baseUrl) {
    if (null == baseUrl || baseUrl.isEmpty) return null;
    if (!_apis["qb"].containsKey(baseUrl)) {
      _apis["qb"][baseUrl] = QBAPI(baseUrl);
    }
    return _apis["qb"][baseUrl];
  }
}

//单利调用
final API api = API();
