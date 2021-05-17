import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

part 'aria2_config_model.g.dart';

/*
* Aria2配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 1)
class Aria2ConfigModel extends ServerConfigModel with HiveObjectMixin {
  //rpc路径
  @HiveField(100, defaultValue: "/jsonrpc")
  String path;

  //通信协议
  @HiveField(101, defaultValue: "POST")
  HTTPMethod method;

  //授权token
  @HiveField(102, defaultValue: "")
  String secretToken;

  Aria2ConfigModel();

  Aria2ConfigModel.create(
    Protocol protocol,
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