import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/clients/transmission/apis/tm_api.dart';
import 'package:bt_service_manager/model/client_info_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/net/client_api.dart';

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
  T getClientApi<T extends ClientAPI>(ServerConfigModel config) =>
      clientApiCaches.getApi<T>(config);

  //请求平台接口对象的总体信息
  Future<ClientInfoModel> loadClientApiInfo(ServerConfigModel config) =>
      getClientApi(config)?.loadClientInfo();

  //初始化接口
  Future init() async {}
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
  Map<String, ClientAPI> apiCaches = {};

  //根据配置类型初始化或提取api接口对象
  T getApi<T extends ClientAPI>(ServerConfigModel config) {
    String cacheKey = config.id;
    if (apiCaches.containsKey(cacheKey)) {
      return apiCaches[cacheKey];
    }
    var api = clientMap[config.type](config);
    if (null != api) apiCaches[cacheKey] = api;
    return api as T;
  }

  //平台客户端接口对象对照表
  final Map<ServerType, ClientAPI Function(ServerConfigModel config)>
      clientMap = {
    ServerType.Aria2: (config) => Aria2API(config),
    ServerType.Transmission: (config) => TMAPI(config),
    ServerType.QBitTorrent: (config) => QBAPI(config),
  };
}
