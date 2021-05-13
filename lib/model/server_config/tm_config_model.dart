import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

/*
* Transmission配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 0)
class TMConfigModel extends ServerConfigModel {
  //rpc路径
  @HiveField(100)
  final String path;

  //通信协议
  @HiveField(101)
  final String method;

  //授权token
  @HiveField(102)
  final String secretToken;

  TMConfigModel.create(
    protocol,
    hostname,
    port,
    this.path,
    this.method,
    this.secretToken,
  ) : super.create(
          protocol,
          hostname,
          port,
        );
}
