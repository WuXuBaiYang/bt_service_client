import 'package:bt_service_manager/model/server_config/server_config_model.dart';

import 'database_manage.dart';

/*
* 服务数据库
* @author jtechjh
* @Time 2021/5/14 9:07 上午
*/
class ServerDatabase extends BaseDatabase {
  //服务器配置容器
  final String _serverConfig = "server_config_box";

  @override
  Future<void> initDB() async {
    //懒加载所有盒子
    await lazyLoadBox([_serverConfig]);
  }

  //添加一个服务器配置
  Future<bool> addServerConfig<T extends ServerConfigModel>(
      String key, T config) async {
    return insert(boxName: _serverConfig, model: config, key: key);
  }

  //以表的形式获取所有服务器配置
  Future<Map> loadAllServerConfig() async {
    return getAllMap(boxName: _serverConfig);
  }
}
