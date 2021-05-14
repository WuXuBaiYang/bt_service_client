import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

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
  Future<void> initDB() async {}

  //添加一个服务器配置
  Future<void> addServerConfig<T extends ServerConfigModel>(T config) async {
    return insert<ServerConfigModel>(_serverConfig, model: config);
  }

  //以表的形式获取所有服务器配置
  Future<List> loadAllServerConfig() async {
    return queryAll<ServerConfigModel>(_serverConfig);
  }

  //监听服务器配置变化
  Future<Stream<BoxEvent>> watchOn(String key) async {
    return watch<ServerConfigModel>(_serverConfig, key: key);
  }
}
