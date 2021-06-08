import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';

part 'tm_config_model.g.dart';

/*
* Transmission配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 3)
// ignore: must_be_immutable
class TMConfigModel extends RPCServerConfigModel with HiveObjectMixin {
  TMConfigModel({
    String alias,
    List<String> tags,
    int flagColor,
    String logoPath,
    bool logoCircle,
    Protocol protocol,
    String hostname,
    num port,
    String path,
    HTTPMethod method,
    String secretToken,
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
          type: ServerType.Transmission,
          path: path,
          method: method,
          secretToken: secretToken,
          id: id,
          createTime: createTime,
          updateTime: updateTime,
        );

  TMConfigModel.copyWith({TMConfigModel config})
      : super(
          alias: config.alias,
          tags: config.tags,
          flagColor: config.flagColor,
          logoPath: config.logoPath,
          logoCircle: config.logoCircle ?? true,
          protocol: config.protocol,
          hostname: config.hostname,
          port: config.port,
          type: ServerType.Transmission,
          path: config.path,
          method: config.method,
          secretToken: config.secretToken,
          orderNum: config.orderNum,
          id: config.id,
          createTime: config.createTime,
          updateTime: config.updateTime,
        );
}
