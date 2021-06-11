import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/clients/transmission/apis/tm_api.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';

/*
* 网络请求入口
* @author jtech
* @Time 2020/6/8 10:17 AM
*/
class API {
  static final API _instance = API._internal();

  factory API() => _instance;

  API._internal();

  //下载平台接口对象缓存
  final clientApiCaches = _ClientApiCache();

  //获取平台接口对象
  getClientApi(ServerConfigModel config) => clientApiCaches.getApi(config);

  //初始化接口
  Future init() async {
    ///遍历数据库，查出需要遍历的服务器实例
  }
}

//单利调用
final API api = API();

/*
* 接口对象缓存
* @author wuxubaiyang
* @Time 2021/6/11 上午9:06
*/
class _ClientApiCache {
  //接口缓存
  Map<String, dynamic> apiCaches = {};

  //根据配置类型初始化或提取api接口对象
  getApi(ServerConfigModel config) {
    String cacheKey = config.id;
    if (apiCaches.containsKey(cacheKey)) {
      return apiCaches[cacheKey];
    }
    var api = _createApi(config);
    if (null != api) apiCaches[config.id] = api;
    return api;
  }

  //根据服务器类型创建api
  _createApi(ServerConfigModel config) {
    switch (config.type) {
      case ServerType.Aria2:
        return Aria2API(config);
      case ServerType.Transmission:
        return TMAPI(config);
      case ServerType.QBitTorrent:
        return QBAPI(config);
      default:
        return;
    }
  }
}
