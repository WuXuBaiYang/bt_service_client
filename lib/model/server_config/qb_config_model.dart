import 'package:bt_service_manager/model/server_config/server_config_model.dart';

/*
* QBitTorrent配置对象
* @author jtechjh
* @Time 2021/5/13 4:20 下午
*/
class QBConfigModel extends ServerConfigModel {
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
