import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:hive/hive.dart';
part 'qb_config_model.g.dart';

/*
* QBitTorrent配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
@HiveType(typeId: 3)
class QBConfigModel extends ServerConfigModel with HiveObjectMixin {
  QBConfigModel();

  QBConfigModel.create(
    protocol,
    hostname,
    port,
  ) : super.create(
          protocol,
          hostname,
          port,
        );
}
