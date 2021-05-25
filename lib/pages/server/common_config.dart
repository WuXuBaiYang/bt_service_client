import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/widgets/form_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 创建/编辑常用服务器配置
* @author jtechjh
* @Time 2021/5/19 4:56 下午
*/
class ModifyCommonConfig<T extends ServerConfigModel> extends StatelessWidget {
  //编辑服务控制器
  final ModifyServerController<T> controller;

  //支持的协议集合
  final List<Protocol> protocols;

  const ModifyCommonConfig({
    Key key,
    @required this.controller,
    @required this.protocols,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildAliasItem(),
          SizedBox(height: 15),
          _buildAddressItem(),
        ],
      ),
    );
  }

  //容器内间距
  final contentPadding =
      const EdgeInsets.symmetric(vertical: 0, horizontal: 15);

  //构建别名项
  _buildAliasItem() {
    return TextFormField(
      initialValue: controller.config.alias ?? "",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "服务器别名",
        contentPadding: contentPadding,
        // border: OutlineInputBorder(),
      ),
      onSaved: (v) => controller.config.alias = v,
    );
  }

  //构建地址子项
  _buildAddressItem() {
    // return UrlAddressFormField(
    //   address: UrlAddressModel.build(
    //     protocol: controller.config.protocol,
    //     hostname: controller.config.hostname,
    //     port: controller.config.port,
    //   ),
    //   protocols: protocols,
    // );
  }
}
