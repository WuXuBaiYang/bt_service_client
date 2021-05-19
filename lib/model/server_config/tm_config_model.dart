import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tm_config_model.g.dart';

/*
* Transmission配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 2)
class TMConfigModel extends ServerConfigModel with HiveObjectMixin {
  //rpc路径
  @HiveField(100)
  String path;

  //通信协议
  @HiveField(101, defaultValue: HTTPMethod.POST)
  HTTPMethod method;

  //授权token
  @HiveField(102)
  String secretToken;

  TMConfigModel();

  TMConfigModel.create(
    String alias,
    List<String> tags,
    Color flagColor,
    String logoPath,
    Protocol protocol,
    String hostname,
    num port,
    this.path,
    this.method,
    this.secretToken,
  ) : super.create(
          alias,
          tags,
          flagColor,
          logoPath,
          protocol,
          hostname,
          port,
          ServerType.Transmission,
        );
}
