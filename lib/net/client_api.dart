import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/client_info_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:dio/dio.dart';

/*
* 平台客户端接口基类
* @author wuxubaiyang
* @Time 2021/6/17 上午10:34
*/
abstract class ClientAPI<T extends ServerConfigModel> {
  //http请求方法
  BaseAPI baseAPI;

  //记录当前接口配置
  T config;

  ClientAPI(this.config) {
    //初始化
    _init();
    //监听配置变化
    dbManage.server.watchOn(config.id).then((stream) {
      stream.listen((event) => _init());
    });
  }

  //加载平台客户端汇总信息
  Future<ClientInfoModel> loadClientInfo();

  //初始化接口配置
  initAPI();

  //获取接口拦截器集合
  List<Interceptor> get interceptors;

  //初始化接口对象
  _init() {
    //初始化接口基类
    baseAPI = BaseAPI(config.baseUrl);
    //添加拦截器
    baseAPI.addInterceptors(interceptors);
    //初始化接口配置
    initAPI();
  }
}
