import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

part 'qb_config_model.g.dart';

/*
* QBitTorrent配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 2)
// ignore: must_be_immutable
class QBConfigModel extends ServerConfigModel with HiveObjectMixin {
  QBConfigModel({
    String alias,
    List<String> tags,
    int flagColor,
    String logoPath,
    bool logoCircle,
    Protocol protocol,
    String hostname,
    num port,
    String id,
    DateTime createTime,
    DateTime updateTime,
  }) : super(
          alias: alias,
          tags: tags,
          flagColor: flagColor,
          logoPath: logoPath,
          logoCircle: logoCircle ?? true,
          protocol: protocol,
          hostname: hostname,
          port: port,
          type: ServerType.QBitTorrent,
          id: id,
          createTime: createTime,
          updateTime: updateTime,
        );

  QBConfigModel.copyWith({QBConfigModel config})
      : super(
          alias: config?.alias,
          tags: config?.tags,
          flagColor: config?.flagColor,
          logoPath: config?.logoPath,
          logoCircle: config?.logoCircle ?? true,
          protocol: config?.protocol,
          hostname: config?.hostname,
          port: config?.port,
          type: ServerType.QBitTorrent,
          orderNum: config?.orderNum,
          id: config?.id,
          createTime: config?.createTime,
          updateTime: config?.updateTime,
        );
}
