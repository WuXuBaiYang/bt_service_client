import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 服务器配置编辑控制器
* @author jtechjh
* @Time 2021/5/19 5:21 下午
*/
class ModifyServerController<T extends ServerConfigModel>
    extends GetxController {
  //服务器配置对象
  final T config;

  //记录rpc的授权密码可视状态
  var rpcTokenVisible = false.obs;

  ModifyServerController({@required this.config});

  //切换rpc授权密码可视状态
  void toggleRPCTokenVisible() {
    rpcTokenVisible.value = !rpcTokenVisible.value;
  }
}
