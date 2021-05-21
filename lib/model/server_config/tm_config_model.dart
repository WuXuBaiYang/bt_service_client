import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tm_config_model.g.dart';

/*
* Transmission配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 3)
class TMConfigModel extends RPCServerConfigModel with HiveObjectMixin {
  TMConfigModel();

  TMConfigModel.create({
    String alias,
    List<String> tags,
    Color flagColor,
    String logoPath,
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
          protocol: protocol,
          hostname: hostname,
          port: port,
          type: ServerType.Transmission,
          path: path,
          method: method,
          secretToken: secretToken,
        );
}
