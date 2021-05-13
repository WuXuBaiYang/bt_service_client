import 'package:bt_service_manager/model/base_model.dart';
import 'package:hive/hive.dart';

/*
* 服务配置对象
* @author jtechjh
* @Time 2021/5/13 4:22 下午
*/
abstract class ServerConfigModel extends BaseModel{
  //协议
  @HiveField(50, defaultValue: "")
  final String protocol;

  //域名/IP
  @HiveField(51, defaultValue: "")
  final String hostname;

  //端口号
  @HiveField(52, defaultValue: 80)
  final num port;

  //拼接基础地址
  String get baseUrl => "$protocol://$hostname:$port";

  ServerConfigModel.create(this.protocol, this.hostname, this.port);
}