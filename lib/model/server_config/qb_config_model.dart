import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'qb_config_model.g.dart';

/*
* QBitTorrent配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 2)
class QBConfigModel extends ServerConfigModel with HiveObjectMixin {
  QBConfigModel();

  QBConfigModel.create({
    String alias,
    List<String> tags,
    Color flagColor,
    String logoPath,
    Protocol protocol,
    String hostname,
    num port,
  }) : super.create(
          alias: alias,
          tags: tags,
          flagColor: flagColor,
          logoPath: logoPath,
          protocol: protocol,
          hostname: hostname,
          port: port,
          type: ServerType.QBitTorrent,
        );
}
