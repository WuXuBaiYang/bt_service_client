import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'aria2_config_model.g.dart';

/*
* Aria2配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 1)
// ignore: must_be_immutable
class Aria2ConfigModel extends RPCServerConfigModel with HiveObjectMixin {
  Aria2ConfigModel()
      : super.create(
          type: ServerType.Aria2,
          logoCircle: true,
        );

  Aria2ConfigModel.create({
    String alias,
    List<String> tags,
    Color flagColor,
    String logoPath,
    bool logoCircle,
    Protocol protocol,
    String hostname,
    num port,
    String path,
    HTTPMethod method,
    String secretToken,
  }) : super.create(
          alias: alias,
          tags: tags,
          flagColor: flagColor,
          logoPath: logoPath,
          logoCircle: logoCircle ?? true,
          protocol: protocol,
          hostname: hostname,
          port: port,
          type: ServerType.Aria2,
          path: path,
          method: method,
          secretToken: secretToken,
        );
}
