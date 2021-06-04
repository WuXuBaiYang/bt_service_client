import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_config.dart';
import 'rpc_config.dart';

/*
* 创建/编辑Aria2服务器
* @author jtechjh
* @Time 2021/5/19 4:21 下午
*/
class ModifyAria2ConfigPage extends StatelessWidget {
  //配置编辑控制器
  final ModifyServerController<Aria2ConfigModel> controller;

  //表单key
  final GlobalKey<FormState> formKey = GlobalKey();

  ModifyAria2ConfigPage(Aria2ConfigModel config)
      : controller =
            ModifyServerController(config: config ?? Aria2ConfigModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.config.isEdited ? "编辑" : "添加"}Aria2服务器"),
        actions: [
          _buildActionDone(context),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModifyRPCConfig(
                controller: controller,
                methods: [
                  HTTPMethod.GET,
                  HTTPMethod.POST,
                ],
                decorationTheme: decorationTheme,
              ),
              ModifyCommonConfig(
                controller: controller,
                protocols: [
                  Protocol.HTTPS,
                  Protocol.HTTP,
                ],
                decorationTheme: decorationTheme,
              ),
            ],
          ),
        ),
        onWillPop: () async {
          return true;
        },
      ),
    );
  }

  //容器样式
  final decorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );

  //构建完成事件
  _buildActionDone(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.done),
      onPressed: () {
        formKey.currentState
          ..validate()
          ..save();
        var a = controller.config;
        print("");
      },
    );
  }
}
