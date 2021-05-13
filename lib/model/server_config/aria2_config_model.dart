import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

/*
* Aria2配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 0)
class Aria2ConfigModel extends ServerConfigModel {
  //rpc路径
  @HiveField(100, defaultValue: "jsonrpc")
  final String path;

  //通信协议
  @HiveField(101, defaultValue: "POST")
  final HTTPMethod method;

  //授权token
  @HiveField(102, defaultValue: "")
  final String secretToken;

  Aria2ConfigModel.create(
    String protocol,
    String hostname,
    num port,
    this.path,
    this.method,
    this.secretToken,
  ) : super.create(
          protocol,
          hostname,
          port,
        );
}
