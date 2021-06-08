import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/common_config.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 创建/编辑QBittorrent服务器
* @author wuxubaiyang
* @Time 2021/6/7 下午2:49
*/
class ModifyQBConfigPage extends StatelessWidget {
  //配置编辑控制器
  final ModifyServerController<QBConfigModel> controller;

  //容器样式
  final decorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );

  ModifyQBConfigPage(QBConfigModel config)
      : controller = ModifyServerController(
          config: QBConfigModel.copyWith(config: config),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${controller.config.isEdited ? "编辑" : "添加"}QBittorrent服务器"),
        actions: _buildActions(context),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              onConfirm: () async => RouteTools.pop(),
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
          onPressed: () => _submitConfig(),
        ),
      ];

  //提交配置信息
  _submitConfig() async {
    if (!controller.confirmForm()) return;
    JAlert.showLoading();
    var config = controller.config;
    if (config.isEdited) {
      await dbManage.server.modifyServerConfig(config);
    } else {
      await dbManage.server.addServerConfig(config);
    }
    JAlert.hideLoading();
    RouteTools.pop(config);
  }
}
