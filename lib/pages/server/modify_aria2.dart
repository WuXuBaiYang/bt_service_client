import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/pages/server/common_config.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/pages/server/rpc_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 创建/编辑Aria2服务器
* @author jtechjh
* @Time 2021/5/19 4:21 下午
*/
class ModifyAria2ConfigPage extends StatelessWidget {
  //配置编辑控制器
  final controller;

  ModifyAria2ConfigPage(Aria2ConfigModel config)
      : controller = Get.put(
            ModifyServerController(config: config ?? Aria2ConfigModel()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.config.isEdited ? "编辑" : "添加"}Aria2服务器"),
        actions: [
          _buildActionDone(context),
        ],
      ),
      body: _buildFormContent(),
    );
  }

  //构建表单内容
  _buildFormContent() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ModifyRPCConfig(),
            // ModifyCommonConfig(),
          ],
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }

  //构建完成事件
  _buildActionDone(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.done),
      onPressed: () {
        Form.of(context)
          ..validate()
          ..save();
      },
    );
  }
}
