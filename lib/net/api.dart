import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';

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
  Aria2API getAria2(Aria2ConfigModel config) {
    if (!_apis["aria2"].containsKey(config.id)) {
      _apis["aria2"][config.id] = Aria2API(config);
    }
    return _apis["aria2"][config.id];
  }

  //qb分流
  QBAPI getQB(QBConfigModel config) {
    if (!_apis["qb"].containsKey(config.id)) {
      _apis["qb"][config.id] = QBAPI(config);
    }
    return _apis["qb"][config.id];
  }

  //初始化接口
  Future init() async {
    ///遍历数据库，查出需要遍历的服务器实例
  }
}

//单利调用
final API api = API();
