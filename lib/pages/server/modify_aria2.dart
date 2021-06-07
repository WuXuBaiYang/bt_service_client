import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/route.dart';
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

  //容器样式
  final decorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );

  ModifyAria2ConfigPage(Aria2ConfigModel config)
      : controller =
            ModifyServerController(config: config ?? Aria2ConfigModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.config.isEdited ? "编辑" : "添加"}Aria2服务器"),
        actions: _buildActions(context),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: ModifyRPCConfig(
                    controller: controller,
                    methods: [
                      HTTPMethod.GET,
                      HTTPMethod.POST,
                    ],
                    decorationTheme: decorationTheme,
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: ModifyCommonConfig(
                    controller: controller,
                    protocols: [
                      Protocol.HTTPS,
                      Protocol.HTTP,
                    ],
                    decorationTheme: decorationTheme,
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          if (controller.hasBeenEdited) {
            AlertTools.alertDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              content: "数据发生过编辑，继续退出将丢失已编辑数据",
              cancel: "取消",
              confirm: "继续退出",
              onConfirm: () async => RouteTools.pop(false),
            );
            return false;
          }
          return true;
        },
      ),
    );
  }

  //构建完成事件
  _buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () => _submitAria2Config(),
        ),
      ];

  //提交配置信息
  _submitAria2Config() {
    JAlert.showLoading();
    formKey.currentState
      ..validate()
      ..save();
    var config = controller.config;
    if (config.isEdited) {
      dbManage.server.modifyServerConfig(config);
    } else {
      dbManage.server.addServerConfig(config);
    }
    JAlert.hideLoading();
    RouteTools.pop(true);
  }
}
