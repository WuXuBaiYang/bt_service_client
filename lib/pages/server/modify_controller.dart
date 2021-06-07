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
  var rpcTokenVisible = true.obs;

  //表单key
  final GlobalKey<FormState> formKey = GlobalKey();

  ModifyServerController({@required this.config}) {
    //首次绘制完成后，存储数据并获取hashcode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState.save();
      configHash = config.hashCode;
    });
  }

  //记录初次对象hash值
  int configHash;

  //判断是否发生过编辑
  bool get hasBeenEdited {
    formKey.currentState.save();
    return configHash != config.hashCode;
  }

  //表单校验并存储
  bool confirmForm() {
    var formState = formKey.currentState;
    var valid = formState.validate();
    if (valid) formState.save();
    return valid;
  }

  //切换rpc授权密码可视状态
  void toggleRPCTokenVisible() =>
      rpcTokenVisible.value = !rpcTokenVisible.value;
}
