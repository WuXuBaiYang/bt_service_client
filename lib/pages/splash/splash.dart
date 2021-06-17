import 'dart:io';

import 'package:bt_service_manager/manage/caches/cache_manager.dart';
import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/manage/routes/page_manage.dart';
import 'package:bt_service_manager/manage/permission_manage.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
* 启动页
* @author jtechjh
* @Time 2021/4/29 4:06 PM
*/
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initAPP(),
        builder: (_, snap) {
          return _buildSplashContent();
        },
      ),
    );
  }

  //初始化app
  _initAPP() async {
    //申请必备权限
    if (!await permissionManage.required()) {
      return await AlertTools.alertDialog(
        content: "必备权限获取失败",
        confirm: "关闭应用",
        onConfirm: () => exit(0),
      );
    }
    //初始化数据库
    await dbManage.init();
    //初始化缓存
    await cacheManage.init();
    //初始化接口
    await api.init();
    //跳转到首页/首次启动页
    return _goNextPage();
  }

  //跳转到首页/首次启动页
  _goNextPage() {
    //跳转到初次配置页
    ///待完成
    //跳转到首页
    pageManage.app.goHomePage();
  }

  //构建启动页内容样式
  _buildSplashContent() {
    ///待完成
    return Container(
      child: Center(
        child: TextButton(
          child: Text("跳转首页"),
          onPressed: () => pageManage.app.goHomePage(),
        ),
      ),
    );
  }
}
