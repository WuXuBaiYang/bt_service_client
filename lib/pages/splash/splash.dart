import 'package:bt_service_manager/manager/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
    await Future.delayed(Duration(seconds: 1));
    //跳转到首页/首次启动页
    return _goNextPage();
  }

  //跳转到首页/首次启动页
  _goNextPage() {
    //跳转到初次配置页
    ///待完成
    //跳转到首页
    PageMG.goHomePage();
  }

  //构建启动页内容样式
  _buildSplashContent() {
    ///待完成
    return Container(
      child: Center(
        child: TextButton(
          child: Text("跳转首页"),
          onPressed: () => PageMG.goHomePage(),
        ),
      ),
    );
  }
}
